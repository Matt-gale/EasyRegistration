import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

//app
import { AppComponent } from '@spa/app/app.component';

//shared
import { SignaturePad } from '@spa/app/shared/signature-pad/signature-pad.component';

@NgModule({
    declarations: [
        AppComponent,
        SignaturePad
    ],
    imports: [
        BrowserModule
    ],
    providers: [],
    bootstrap: [AppComponent]
})
export class AppModule { }
