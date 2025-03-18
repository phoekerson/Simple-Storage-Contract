// Import necessary Starknet modules
#[starknet::contract]
mod student_contract {
    use starknet::storage;

    
    struct State {
        name: felt, 
        age: felt,  
    }

    
    #[constructor]
    fn constructor() -> State {
        State {
            name: 20, 
            age: 20,
        }
    }

    
    #[external]
    fn update_student_data(
        &mut self,
        new_name: felt, 
        new_age: felt,  
    ) {
        self.name = new_name; 
        self.age = new_age;   
    }

   
    #[view]
    fn get_student_data(&self) -> (felt, felt) {
        (self.name, self.age) 
    }
}
