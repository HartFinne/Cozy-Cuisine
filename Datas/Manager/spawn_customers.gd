extends Node

var spawned_customers = []

# This function will add customers to the global list
func add_customer(customer):
	spawned_customers.append(customer)

# This function can be used to get the list of all customers
func get_customers():
	return spawned_customers
