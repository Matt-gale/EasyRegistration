import { Component, ViewEncapsulation, ViewChild, HostListener, Input, ElementRef, Output, EventEmitter } from '@angular/core';


//https://github.com/szimek/signature_pad/blob/master/src/signature_pad.js

@Component({
    moduleId: module.id,
    selector: 'signature-pad',
    templateUrl: 'signature-pad.component.html',
    styleUrls: ['signature-pad.component.css'],
    encapsulation: ViewEncapsulation.None,
})

export class SignaturePad {
    
    velocityFilterWeight: number;
    minWidth: number;
    maxWidth: number;

    dotSize: number;
    penColor: string;
    backgroundColor: string;

    _lastVelocity = 0;
    _lastWidth = 0;

    onBegin;
    onEnd;

    @ViewChild("canvaspad") _canvas: ElementRef;
    _ctx;

    points;

    throttle;

    @Input() options: SignaturePadOptions;
    @Output() output = new EventEmitter<string>();

    constructor() {

        
    }

    ngAfterViewInit() {

        const opts = this.options || new SignaturePadOptions();

        this.velocityFilterWeight = opts.velocityFilterWeight || 0.7;
        this.minWidth = opts.minWidth || 0.5;
        this.maxWidth = opts.maxWidth || 2.5;
        this.throttle = 'throttle' in opts ? opts.throttle : 16; // in miliseconds

        if (this.throttle) {
            this._strokeMoveUpdate = new Throttle().Throttle(this._strokeUpdate, this.throttle);
        } else {
            this._strokeMoveUpdate = this._strokeUpdate;
        }

        this.dotSize = opts.dotSize || (this.minWidth + this.maxWidth) / 2;

        this.penColor = opts.penColor || 'black';
        this.backgroundColor = opts.backgroundColor || 'rgba(0,0,0,0)';
        this.onBegin = opts.onBegin;
        this.onEnd = opts.onEnd;

        this._ctx = this._canvas.nativeElement.getContext('2d');
        this.clear();

        this._handleMouseEvents();
        this._handleTouchEvents();

        window.onresize = (e) => {
            this.resizeCanvas();
        }

        this.resizeCanvas();
    }

    _data;

    _isEmpty;
    isEmpty() {
        this._isEmpty;
    }

    // Adjust canvas coordinate space taking into account pixel ratio,
    // to make it look crisp on mobile devices.
    // This also causes canvas to be cleared.
    resizeCanvas() {
        // When zoomed out to less than 100%, for some very strange reason,
        // some browsers report devicePixelRatio as less than 1
        // and only part of the canvas is cleared then.
        var ratio = Math.max(window.devicePixelRatio || 1, 1);
        this._canvas.nativeElement.width = this._canvas.nativeElement.offsetWidth * ratio;
        this._canvas.nativeElement.height = this._canvas.nativeElement.offsetHeight * ratio;
        this._canvas.nativeElement.getContext("2d").scale(ratio, ratio);
    }
    
    clear() {
        const ctx = this._ctx;

        ctx.fillStyle = this.backgroundColor;
        ctx.clearRect(0, 0, this._canvas.nativeElement.width, this._canvas.nativeElement.height);
        ctx.fillRect(0, 0, this._canvas.nativeElement.width, this._canvas.nativeElement.height);

        this._data = [];
        this._reset();
        this._isEmpty = true;
    }

    _reset() {
        this.points = [];
        this._lastVelocity = 0;
        this._lastWidth = (this.minWidth + this.maxWidth) / 2;
        this._ctx.fillStyle = this.penColor;
    }

    fromDataURL(dataUrl, options: any) {
        const image = new Image();
        const ratio = options.ratio || window.devicePixelRatio || 1;
        const width = options.width || (this._canvas.nativeElement.width / ratio);
        const height = options.height || (this._canvas.nativeElement.height / ratio);

        this._reset();
        image.src = dataUrl;
        image.onload = () => {
            this._ctx.drawImage(image, 0, 0, width, height);
        };
        this._isEmpty = false;
    }

    toDataURL(type, ...options) {
        switch (type) {
            case 'image/svg+xml':
                return this._toSVG();
            default:
                return this._canvas.nativeElement.toDataURL(type, ...options);
        }
    }

    _toSVG() {
        const pointGroups = this._data;
        const canvas = this._canvas;
        const ratio = Math.max(window.devicePixelRatio || 1, 1);
        const minX = 0;
        const minY = 0;
        const maxX = canvas.nativeElement.width / ratio;
        const maxY = canvas.nativeElement.height / ratio;
        const svg = document.createElementNS('http://www.w3.org/2000/svg', 'svg');

        svg.setAttributeNS(null, 'width', canvas.nativeElement.width);
        svg.setAttributeNS(null, 'height', canvas.nativeElement.height);

        this._fromData(
            pointGroups,
            (curve, widths, color) => {
                const path = document.createElement('path');

                // Need to check curve for NaN values, these pop up when drawing
                // lines on the canvas that are not continuous. E.g. Sharp corners
                // or stopping mid-stroke and than continuing without lifting mouse.
                if (!isNaN(curve.control1.x) &&
                    !isNaN(curve.control1.y) &&
                    !isNaN(curve.control2.x) &&
                    !isNaN(curve.control2.y)) {
                    const attr = `M ${curve.startPoint.x.toFixed(3)},${curve.startPoint.y.toFixed(3)} `
                        + `C ${curve.control1.x.toFixed(3)},${curve.control1.y.toFixed(3)} `
                        + `${curve.control2.x.toFixed(3)},${curve.control2.y.toFixed(3)} `
                        + `${curve.endPoint.x.toFixed(3)},${curve.endPoint.y.toFixed(3)}`;

                    path.setAttribute('d', attr);
                    path.setAttribute('stroke-width', (widths.end * 2.25).toFixed(3));
                    path.setAttribute('stroke', color);
                    path.setAttribute('fill', 'none');
                    path.setAttribute('stroke-linecap', 'round');

                    svg.appendChild(path);
                }
            },
            (rawPoint) => {
                const circle = document.createElement('circle');
                const dotSize = this.dotSize;
                circle.setAttribute('r', dotSize.toString());
                circle.setAttribute('cx', rawPoint.x);
                circle.setAttribute('cy', rawPoint.y);
                circle.setAttribute('fill', rawPoint.color);

                svg.appendChild(circle);
            },
        );

        const prefix = 'data:image/svg+xml;base64,';
        const header = '<svg'
            + ' xmlns="http://www.w3.org/2000/svg"'
            + ' xmlns:xlink="http://www.w3.org/1999/xlink"'
            + ` viewBox="${minX} ${minY} ${maxX} ${maxY}"`
            + ` width="${maxX}"`
            + ` height="${maxY}"`
            + '>';
        let body = svg.innerHTML;

        // IE hack for missing innerHTML property on SVGElement
        if (body === undefined) {
            const dummy = document.createElement('dummy');
            const nodes = svg.childNodes;
            dummy.innerHTML = '';

            for (let i = 0; i < nodes.length; i += 1) {
                dummy.appendChild(nodes[i].cloneNode(true));
            }

            body = dummy.innerHTML;
        }

        const footer = '</svg>';
        const data = header + body + footer;

        return prefix + btoa(data);
    }

    _mouseButtonDown: boolean

    @HostListener('mousedown', ['$event'])
    _handleMouseDown(event) {
        if (event.which === 1) {
            this._mouseButtonDown = true;
            this._strokeBegin(event);
        }
    }

    @HostListener('mousemove', ['$event'])
    _handleMouseMove(event) {
        if (this._mouseButtonDown) {
            this._strokeMoveUpdate(event);
        }
    }

    @HostListener('mouseup', ['$event'])
    _handleMouseUp(event) {
        if (event.which === 1 && this._mouseButtonDown) {
            this._mouseButtonDown = false;
            this._strokeEnd(event);
        }
    };

    @HostListener('touchstart', ['$event'])
    _handleTouchStart(event) {
        if (event.targetTouches.length === 1) {
            const touch = event.changedTouches[0];
            this._strokeBegin(touch);
        }
    };

    @HostListener('touchmove', ['$event'])
    _handleTouchMove(event) {
        // Prevent scrolling.
        event.preventDefault();

        const touch = event.targetTouches[0];
        this._strokeMoveUpdate(touch);
    };

    @HostListener('touchend', ['$event'])
    _handleTouchEnd(event) {
        const wasCanvasTouched = event.target === this._canvas;
        if (wasCanvasTouched) {
            event.preventDefault();
            this._strokeEnd(event);
        }
    }

    _strokeBegin(event) {
        this._data.push([]);
        this._reset();
        this._strokeUpdate(event);

        if (typeof this.onBegin === 'function') {
            this.onBegin(event);
        }
    }

    _strokeUpdate(event) {
        const x = event.clientX;
        const y = event.clientY;

        const point = this._createPoint(x, y, null);
        const cw = this._addPoint(point);

        if (cw['curve'] && cw['widths']) {
            this._drawCurve(cw['curve'], cw['widths'].start, cw['widths'].end);
        }

        this._data[this._data.length - 1].push({
            x: point.x,
            y: point.y,
            time: point.time,
            color: this.penColor,
        });
    }

    _addPoint(point) {
        const points = this.points;
        let tmp;

        points.push(point);

        if (points.length > 2) {
            // To reduce the initial lag make it work with 3 points
            // by copying the first point to the beginning.
            if (points.length === 3) points.unshift(points[0]);

            tmp = this._calculateCurveControlPoints(points[0], points[1], points[2]);
            const c2 = tmp.c2;
            tmp = this._calculateCurveControlPoints(points[1], points[2], points[3]);
            const c3 = tmp.c1;
            const curve = new Bezier(points[1], c2, c3, points[2]);
            const widths = this._calculateCurveWidths(curve);

            // Remove the first element from the list,
            // so that we always have no more than 4 points in points array.
            points.shift();

            return { 'curve': curve, 'widths': widths };
        }

        return {};
    }

    _calculateCurveWidths(curve) {
        const startPoint = curve.startPoint;
        const endPoint = curve.endPoint;
        const widths = { start: null, end: null };

        const velocity = (this.velocityFilterWeight * endPoint.velocityFrom(startPoint))
            + ((1 - this.velocityFilterWeight) * this._lastVelocity);

        const newWidth = this._strokeWidth(velocity);

        widths.start = this._lastWidth;
        widths.end = newWidth;

        this._lastVelocity = velocity;
        this._lastWidth = newWidth;

        return widths;
    }

    _strokeWidth(velocity) {
        return Math.max(this.maxWidth / (velocity + 1), this.minWidth);
    }

    _calculateCurveControlPoints(s1, s2, s3) {
        const dx1 = s1.x - s2.x;
        const dy1 = s1.y - s2.y;
        const dx2 = s2.x - s3.x;
        const dy2 = s2.y - s3.y;

        const m1 = { x: (s1.x + s2.x) / 2.0, y: (s1.y + s2.y) / 2.0 };
        const m2 = { x: (s2.x + s3.x) / 2.0, y: (s2.y + s3.y) / 2.0 };

        const l1 = Math.sqrt((dx1 * dx1) + (dy1 * dy1));
        const l2 = Math.sqrt((dx2 * dx2) + (dy2 * dy2));

        const dxm = (m1.x - m2.x);
        const dym = (m1.y - m2.y);

        const k = l2 / (l1 + l2);
        const cm = { x: m2.x + (dxm * k), y: m2.y + (dym * k) };

        const tx = s2.x - cm.x;
        const ty = s2.y - cm.y;

        return {
            c1: new Point(m1.x + tx, m1.y + ty, null),
            c2: new Point(m2.x + tx, m2.y + ty, null),
        };
    }

    _createPoint(x, y, time) {
        const rect = this._canvas.nativeElement.getBoundingClientRect();

        return new Point(
            x - rect.left,
            y - rect.top,
            time || new Date().getTime(),
        );
    }

    _drawCurve(curve, startWidth, endWidth) {
        const ctx = this._ctx;
        const widthDelta = endWidth - startWidth;
        const drawSteps = Math.floor(curve.length());

        ctx.beginPath();

        for (let i = 0; i < drawSteps; i += 1) {
            // Calculate the Bezier (x, y) coordinate for this step.
            const t = i / drawSteps;
            const tt = t * t;
            const ttt = tt * t;
            const u = 1 - t;
            const uu = u * u;
            const uuu = uu * u;

            let x = uuu * curve.startPoint.x;
            x += 3 * uu * t * curve.control1.x;
            x += 3 * u * tt * curve.control2.x;
            x += ttt * curve.endPoint.x;

            let y = uuu * curve.startPoint.y;
            y += 3 * uu * t * curve.control1.y;
            y += 3 * u * tt * curve.control2.y;
            y += ttt * curve.endPoint.y;

            const width = startWidth + (ttt * widthDelta);
            this._drawPoint(x, y, width);
        }

        ctx.closePath();
        ctx.fill();
    }

    _handleMouseEvents() {
        this._mouseButtonDown = false;
    }

    _handleTouchEvents() {
        this._canvas.nativeElement.style.msTouchAction = 'none';
        this._canvas.nativeElement.style.touchAction = 'none';
    }

    _drawPoint(x, y, size) {
        const ctx = this._ctx;

        ctx.moveTo(x, y);
        ctx.arc(x, y, size, 0, 2 * Math.PI, false);
        this._isEmpty = false;
    }

    _drawDot(point) {
        const ctx = this._ctx;
        const width = this.dotSize;

        ctx.beginPath();
        this._drawPoint(point.x, point.y, width);
        ctx.closePath();
        ctx.fill();
    }

    _strokeEnd(event) {
        const canDrawCurve = this.points.length > 2;
        const point = this.points[0]; // Point instance

        if (!canDrawCurve && point) {
            this._drawDot(point);
        }

        if (point) {
            const lastPointGroup = this._data[this._data.length - 1];
            const lastPoint = lastPointGroup[lastPointGroup.length - 1]; // plain object

            // When drawing a dot, there's only one point in a group, so without this check
            // such group would end up with exactly the same 2 points.
            if (!point.equals(lastPoint)) {
                lastPointGroup.push({
                    x: point.x,
                    y: point.y,
                    time: point.time,
                    color: this.penColor,
                });
            }
        }

        if (typeof this.onEnd === 'function') {
            this.onEnd(event);
        }
    }

    _strokeMoveUpdate

    _fromData(pointGroups, drawCurve, drawDot) {
        for (let i = 0; i < pointGroups.length; i += 1) {
            const group = pointGroups[i];

            if (group.length > 1) {
                for (let j = 0; j < group.length; j += 1) {
                    const rawPoint = group[j];
                    const point = new Point(rawPoint.x, rawPoint.y, rawPoint.time);
                    const color = rawPoint.color;

                    if (j === 0) {
                        // First point in a group. Nothing to draw yet.
                        this._reset();
                        this._addPoint(point);
                    } else if (j !== group.length - 1) {
                        // Middle point in a group.
                        const curvewidths = this._addPoint(point);
                        if (curvewidths['curve'] && curvewidths['widths']) {
                            drawCurve(curvewidths['curve'], curvewidths['widths'], color);
                        }
                    } else {
                        // Last point in a group. Do nothing.
                    }
                }
            } else {
                this._reset();
                const rawPoint = group[0];
                drawDot(rawPoint);
            }
        }
    }

    fromData(pointGroups) {
        this.clear();

        this._fromData(
            pointGroups,
            (curve, widths) => this._drawCurve(curve, widths.start, widths.end),
            rawPoint => this._drawDot(rawPoint),
        );

        this._data = pointGroups;
    }

    toData() {
        return this._data;
    };
    
    saveAsPNG(event) {
        if (this.isEmpty()) {
            alert("Please provide signature first.");
        } else {
            this.output.emit(this.toDataURL(null))
        }
    }

    saveAsSVG(event) {
        if (this.isEmpty()) {
            alert("Please provide signature first.");
        } else {
            this.output.emit(this.toDataURL('image/svg+xml'));
        }
    }

}

//https://github.com/szimek/signature_pad/blob/master/src/bezier.js
export class Bezier {
    startPoint;
    control1;
    control2;
    endPoint;

    constructor(startPoint, control1, control2, endPoint) {
        this.startPoint = startPoint;
        this.control1 = control1;
        this.control2 = control2;
        this.endPoint = endPoint;
    }

    length() {
        const steps = 10;
        let length = 0;
        let px;
        let py;

        for (let i = 0; i <= steps; i += 1) {
            const t = i / steps;
            const cx = this._point(
                t,
                this.startPoint.x,
                this.control1.x,
                this.control2.x,
                this.endPoint.x,
            );
            const cy = this._point(
                t,
                this.startPoint.y,
                this.control1.y,
                this.control2.y,
                this.endPoint.y,
            );
            if (i > 0) {
                const xdiff = cx - px;
                const ydiff = cy - py;
                length += Math.sqrt((xdiff * xdiff) + (ydiff * ydiff));
            }
            px = cx;
            py = cy;
        }

        return length;
    }

    _point(t, start, c1, c2, end) {
        return (       start * (1.0 - t) * (1.0 - t)  * (1.0 - t))
             + (3.0 *  c1    * (1.0 - t) * (1.0 - t)  * t)
             + (3.0 *  c2    * (1.0 - t) * t          * t)
             + (       end   * t         * t          * t);
    }
}

//https://github.com/szimek/signature_pad/blob/master/src/point.js
export class Point {
    x;
    y;
    time;

    constructor(x, y, time) {
        this.x = x;
        this.y = y;
        this.time = time || new Date().getTime();
    }

    velocityFrom(start) {
        return (this.time !== start.time) ? this.distanceTo(start) / (this.time - start.time) : 1;
    }

    distanceTo(start) {
        return Math.sqrt(Math.pow(this.x - start.x, 2) + Math.pow(this.y - start.y, 2));
    }

    equals(other) {
        return this.x === other.x && this.y === other.y && this.time === other.time;
    }
}

//https://github.com/szimek/signature_pad/blob/master/src/throttle.js
//http://stackoverflow.com/a/27078401/815507
export class Throttle {
    constructor() { }

    public Throttle(func, wait) {
        var context, args, result;
        var timeout = null;
        var previous = 0;
        var later = function () {
            previous = 0;
            timeout = null;
            result = func.apply(context, args);
            if (!timeout) context = args = null;
        };
        return function () {
            var now = Date.now();
            if (!previous) previous = now;
            var remaining = wait - (now - previous);
            context = this;
            args = arguments;
            if (remaining <= 0 || remaining > wait) {
                if (timeout) {
                    clearTimeout(timeout);
                    timeout = null;
                }
                previous = now;
                result = func.apply(context, args);
                if (!timeout) context = args = null;
            } else if (!timeout) {
                timeout = setTimeout(later, remaining);
            }
            return result;
        }
    }
}

export class SignaturePadOptions {
    public dotSize: number;
    public minWidth: number;
    public maxWidth: number;
    public throttle: number;
    public backgroundColor: string;
    public penColor: string;
    public velocityFilterWeight: number;
    public onBegin: number;
    public onEnd: number;
}
