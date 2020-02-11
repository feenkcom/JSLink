var fs = require('fs');
var SoBrowser = require('../../model/browser');
var SoCookie = require('../../model/cookie');

class BrowserFeature {
    constructor(id, name) {
        this.browser = new SoBrowser(id, name);
    }

    getBrowser() {
        return this.browser;
    }

    static createFromFile(filePath) {
        let rawData = fs.readFileSync(filePath);
        let browserData = JSON.parse(rawData);

        let feature = new this(browserData.id, browserData.name);
        browserData.cookies.forEach(cookieData => {
            feature.getBrowser().addCookie(new SoCookie(
                cookieData.id,
                cookieData.baseDomain,
                cookieData.name,
                cookieData.value,
                cookieData.categories,
            ));
        });
        return feature;
    }

    static createFromDummyData(browserId, browsername) {
        let feature = new this(browserId, browsername);
        feature.getBrowser().addCookie(new SoCookie(
            10010,
           'google.com',
            'CGIC',
            'hagat'
        ));
        feature.getBrowser().addCookie(new SoCookie(
            10011,
            'dropbox.com',
            'locale',
            'en_GB'
        ));
        feature.getBrowser().addCookie(new SoCookie(
            10012,
            'github.com',
            'logged_in',
            'no'
        ));
    }
}

module.exports = BrowserFeature;