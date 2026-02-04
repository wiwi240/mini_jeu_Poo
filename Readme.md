# ILS VEULENT TOUS MA POO - Battle Arena

A tactical combat simulation based on **Object-Oriented Programming (OOP)** principles, developed in Ruby. This project simulates a survival game where a human player faces waves of automated enemies.

---

### 🚀 Features
* **Dynamic Combat System**: Management of Life Points (LP) and damage calculation based on probability (dice system).
* **OOP Inheritance**: Implementation of a `HumanPlayer` class inheriting from `Player` with special abilities (weapon and health search).
* **Inventory Management**: Weapon leveling system to increase striking power.
* **Complete Game Engine**: Management of a 10-enemy reserve with random spawning on the field via the `Game` class.

---

### 🛠️ Technical Architecture

| Concept | Application in the project |
| :--- | :--- |
| **Encapsulation** | Use of protected attributes and `attr_accessor` for data management. |
| **Inheritance** | Extension of the `Player` class to create a hero with unique mechanics. |
| **Random Logic** | Use of `rand` to simulate uncertainty in combat and loot. |
| **Abstraction** | The main file delegates all complex logic to `Game` class objects. |

---

### 💻 Installation

1.  **Clone the repository**:
    ```bash
    git clone [https://github.com/your-username/mini_jeu_poo.git](https://github.com/your-username/mini_jeu_poo.git)
    cd mini_jeu_poo
    ```

2.  **Install dependencies**:
    ```bash
    bundle install
    ```

---

### 🎮 How to Play

To launch the final version of the game:
```bash
ruby app.rb