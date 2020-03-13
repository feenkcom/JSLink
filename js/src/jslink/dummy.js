/*
 * A simple test class that can be used for testing :-)
 */

class TestClass {
	constructor() {
		this.a_value = "an initial value"; }

	set(newValue) {
		this.a_value = newValue;
		return this; }

	get() {
		return this.a_value; }

	hw() {
		return "Hello, World"; }
}

module.exports = TestClass;
