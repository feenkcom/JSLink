class View {
    constructor() {
        this.viewTitle = 'Unknown';
        this.viewPriority = 1;
    }

    title(title) {
        this.viewTitle = title;
        return this;
    }

    priority(priority) {
        this.viewPriority = priority;
        return this;
    }

    getTitle() {
        return this.viewTitle;
    }

    asDictionaryForExport() {
        return { 
            title: this.viewTitle,
            priority: this.viewPriority,
        }
    }
}

module.exports = View;