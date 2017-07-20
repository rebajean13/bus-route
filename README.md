# bus-route
A quick project to get the next available departure time for a metro transit bus or train

# Running the bus-routes project 

1. Clone the repository from git or download the source code to your local drive 
2. Install latest ruby on your machine https://www.ruby-lang.org/en/documentation/installation/
3. Verify that ruby was installed by checking the installed version 
	* ruby -v
4. From your preferred terminal, navigate to the BusRoutes directory and launch the 'busroutes.rb' ruby file 
	* ruby ./busroutes.rb
	* When prompted, enter the name of the route
	* When prompted, enter the name of the direction
	* When prompted, enter the name of the stop 
	* The number of minutes until the next departure will be returned 

# Running the bus-routes rspec tests 

I wrote a suite of unit tests to verify behavior of some helper functions. 
It is far from an exhaustive list, I have plenty of ideas how it could be improved upon.

To run the tests:

1. Install rspec on your local machine
	* gem install rspec
2. From your preferred terminal, navigate to the BusRoutes directory and run the following command:
	* rspec spec spec/transit_helper_tests.rb
	* The output of the tests will be displayed in the terminal
