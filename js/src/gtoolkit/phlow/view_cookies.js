var View = require('./view');

class CookiesView extends View {
    constructor() {
        super();
        this.cookiesCallback = () => {[]};
        this.title('Cookies');
    }

    cookies(cookiesCallback) {
        this.cookiesCallback = cookiesCallback;
        return this;
    }

    computeItems() {
        return this.cookiesCallback();
    }

    asDictionaryForExport() {
        let exportData = super.asDictionaryForExport();
        exportData['viewName'] = 'GtDeclarativeCookiesView';
        exportData['dataTransport'] = 1;
        exportData['cookiesData'] = this.computeItems().map( 
            cookie => {return {
                id: cookie.getId(),
                name: cookie.getName(),
                value: cookie.getValue(),
                baseDomain: cookie.getBaseDomain(),
            }}
        );
        return exportData;
    }
}

module.exports = CookiesView;
