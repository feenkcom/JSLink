//
// This is a simple class that can be instantiated and demonstrates Gt views
//

var ViewBuilder = require('../gtoolkit/phlow/view_builder.js');

class TestClass {
    constructor () {
        this.text = 'My Text';
        this.number = 42;
		this.simplelist = [ 1, 'a', 'last' ];
		this.array = [ [1, 'first'], [2, 'second'], [3, 'third']];
    }

	setText(newText) {
		this.text = newText;
		return this; }

	setNumber(newNumber) {
		this.number = newNumber;
		return this; }

	getText() {
		return this.text; }

	getNumber() {
		return this.number; }

	// A recursive factorial that allows a stack to be built and traversed,
	// for debugging testing.
	factorial(aNumber) {
		let result;
		if (aNumber == 1)
			{ result = 1; debugger; }
		else
			{ result = aNumber * this.factorial(aNumber - 1); }
		return result; }

    gtViewList(builder) {
        return builder.list()
            .title('Simple List')
            .priority(2)
            .items(() => this.simplelist)
            .itemFormat(item => item)
    }

    gtViewTable(builder) {
        return builder.columnedList()
            .title('List')
            .priority(3)
            .items(() => this.array)
            .column('Number', item => item[0])
            .column('Value', item => item[1])
    }

    gtViewSummary(builder) {
        return builder.textEditor()
            .title('Summary')
            .priority(1)
            .setString('A Demo Object, number ' + this.number, ', text: ' + this.text);
    }
}

module.exports = TestClass;

