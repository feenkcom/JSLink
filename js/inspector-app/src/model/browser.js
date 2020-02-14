var SoEntity = require('./entity');
var ViewBuilder = require('../gtoolkit/phlow/view_builder.js');

class SoBrowser extends SoEntity {
    constructor (id, name) {
        super(id);
        this.name = name;
        this.cookies = [];
    }

    getName() {
        return this.name;
    }

    addCookie(cookie) {
        this.cookies.push(cookie);
    }

    cookiesGroupedByRootDomain() {
        return this.cookiesGroupedBy(cookie => cookie.getRootDomainName());
    }

    cookiesGroupedByBaseDomain() {
        return this.cookiesGroupedBy(cookie => cookie.getBaseDomain());
    }

    cookiesGroupedByValidity() {
        return this.cookiesGroupedBy(cookie => cookie.categoryValue('validityDuration'));
    }

    cookiesGroupedBy(groupingCallback) {
        let groupedCookies = new Map();
        this.cookies.forEach(cookie => {
            let property = groupingCallback(cookie);
            var group = groupedCookies.get(property);
            if (!group) {
                group = [];
                groupedCookies.set(property, group);
            } 
            group.push(cookie);
        });
        return groupedCookies;
    }

    gtViewCookieNamesList(builder) {
        return builder.list()
            .title('Cookie names')
            .priority(2)
            .items(() => this.cookies)
            .itemFormat(cookie => cookie.getName());
    }

    gtViewCookieDetails(builder) {
        return builder.table()
            .title('Cookie details')
            .priority(2)
            .items(() => this.cookies)
            .column('Name', cookie => cookie.getName())
            .column('Base domain', cookie => cookie.getBaseDomain())
            .column('Value', cookie => cookie.getValue())
    }

    gtViewCookies(builder) {
        return builder.cookies()
            .title('Cookies')
            .priority(3)
            .cookies(() => this.cookies);
    }

    gtViewCookiesByBaseDomain(builder) {
        return builder.table()
            .title('Cookies by domain')
            .priority(4)
            .items(() => 
                Array.from(this.cookiesGroupedByBaseDomain().entries()).sort(
                    (assocA, assocB)=> assocA[1].length <= assocB[1].length))
            .column('Domain', item => item[0])
            .column('Cookies', item => item[1].length);
    }
    
    gtViewCookiesByValidityMap(builder) {
        return builder.circularPack()
            .title('Cookies by validity')
            .priority(1)
            .items(() => 
                Array.from(this.cookiesGroupedByValidity().entries()))
            .circleName(item => item[0])
            .circleSize(item => { return item[1].length * 10 });
    }

    gtViewBasicUIDetails(builder) {
        return builder.list()
            .title('UI Details')
            .priority(50)
            .items(() =>
                [  {numberOfCookies: this.cookies.length},
                   {numberOfPageVisits: 0},
                   {appOverviewColor: '18A15E'},
                ]
            )
            .itemFormat(item => JSON.stringify(item));;
    }
}

module.exports = SoBrowser;

