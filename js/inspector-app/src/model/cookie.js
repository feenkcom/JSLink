var SoEntity = require('./entity');

class SoCookie extends SoEntity {
    constructor (id, baseDomain, name, value, categories) {
        super(id);
        this.baseDomain = baseDomain;
        this.name = name;
        this.value = value;
        this.categories = categories;
    }

    getBaseDomain() {
        return this.baseDomain;
    }

    getName() {
        return this.name;
    }

    getValue() {
        return this.value;
    }

    getRootDomainName() {
        let indeOfDot = this.baseDomain.lastIndexOf('.');
        if (indeOfDot == -1) {
            indeOfDot = 0;
        }
        return this.baseDomain.substring(indeOfDot, this.baseDomain.length-1);
    }

    categoryValue(categoryName) {
        if (this.categories) {
            return this.categories[categoryName] || 'Undefined' };
        return 'Undefined';
    }

    gtViewCookieDetailsList(builder) {
        return builder.list()
            .title('Details')
            .items(() =>  [ 
                this.baseDomain , 
                this.name,
                this.value,
             ]);
    }
}

module.exports = SoCookie;