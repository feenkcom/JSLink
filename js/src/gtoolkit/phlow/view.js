class View {
    constructor() {
        this.viewTitle = 'Unknown';
        this.viewPriority = 1;
		this.accessor = null;
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

	set_accessor(accessor_function) {
		this.accessor = accessor_function;
		return this;
	}

    asDictionaryForExport() {
        return { 
            title: this.viewTitle,
            priority: this.viewPriority,
			__jsLinkImmediate: true
        }
    }

}

module.exports = View;
