import { Component, ViewEncapsulation  } from '@angular/core';

import { SignaturePadOptions } from '@spa/app/shared/signature-pad/signature-pad.component'

@Component({
    moduleId: module.id,
    selector: 'app-root',
    templateUrl: 'app.component.html',
    styleUrls: ['app.component.css'],
    encapsulation: ViewEncapsulation.None,
})
export class AppComponent {
    title = 'app';

    signatureOptions: SignaturePadOptions = new SignaturePadOptions();

    constructor() {
        this.signatureOptions.minWidth = 5;
        this.signatureOptions.maxWidth = 10;
        this.signatureOptions.penColor = "rgb(66, 133, 244)";
    }
}