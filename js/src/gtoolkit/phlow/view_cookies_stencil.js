var View = require('./view');

class CookiesStencilView extends View {
    constructor() {
        super();
        this.cookiesCallback = () => {[]};
        this.title('Cookies Stencil');
        this.stencilClassName = null;
    }

    cookies(cookiesCallback) {
        this.cookiesCallback = cookiesCallback;
        return this;
    }


    stencil(stencilName) {
        this.stencilClassName = stencilName;
        return this;
    }

    computeItems() {
        return this.cookiesCallback();
    }

    asDictionaryForExport() {
        let exportData = super.asDictionaryForExport();
        exportData['viewName'] = 'GtDeclarativeCookiesStencilView';
        exportData['dataTransport'] = 1;
        exportData['stencilClassName'] = this.stencilClassName;
        exportData['cookiesData'] = this.computeItems().map( 
            cookie => {
                let rawData = cookie.rawData;
                rawData.__jsLinkImmediate = true;
                return rawData;
            }
        );
        return exportData;
    }
}

module.exports = CookiesStencilView;
