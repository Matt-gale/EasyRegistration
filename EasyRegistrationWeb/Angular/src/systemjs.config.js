(function (global) {
    // map tells the System loader where to look for things

    var version = "4.0.2";

    var map = {
        'app': 'app',
        '@angular': 'https://unpkg.com/@angular',
        '@angular/common': 'https://unpkg.com/@angular/common@' + version,
        '@angular/compiler': 'https://unpkg.com/@angular/compiler@' + version,
        '@angular/core': 'https://unpkg.com/@angular/core@' + version,
        '@angular/router': 'https://unpkg.com/@angular/router@3.4.4',
        '@angular/forms': 'https://unpkg.com/@angular/forms@' + version,
        '@angular/http': 'https://unpkg.com/@angular/http@' + version,
        '@angular/platform-browser': 'https://unpkg.com/@angular/platform-browser@' + version,
        '@angular/platform-browser-dynamic': 'https://unpkg.com/@angular/platform-browser-dynamic@' + version,
        'rxjs': 'https://unpkg.com/rxjs@5.0.3'
    };

    // packages tells the System loader how to load when no filename and/or no extension
    var packages = {
        'app': { main: 'main.js', defaultExtension: 'js' },
        'rxjs': { defaultExtension: 'js' }
    };

    var ngPackageNames = [
        'common',
        'compiler',
        'core',
        'forms',
        'http',
        'platform-browser',
        'platform-browser-dynamic',
        'router'
    ];

    // Add package entries for angular packages
    ngPackageNames.forEach(function (pkgName) {
        let version = "@4.0.2";

        packages['@angular/' + pkgName] = 'https://unpkg.com/@angular/' + pkgName + version;
    });

    var config = {
        baseURL: '/',
        map: map,
        packages: packages
    };

    System.config(config);

})(this);