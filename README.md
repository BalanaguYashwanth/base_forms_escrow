# FormsEscrow Smart Contract

## Overview
The **FormsEscrow** contract allows form owners to create multiple forms with associated budgets and reward mechanisms. Each form has a unique ID (`formId`, `uid`) and can distribute rewards to users based on their form responses. The contract also supports dynamic reward allocation and escrow management, making it ideal for use cases involving form-based surveys and incentivized responses.

## Features
- **Form Creation**: Form owners can create multiple forms under their ownership, each with a specified budget, reward per response (cost per response), and duration.

- **Escrow Management**: Each form has an associated escrow (budget) from which rewards are distributed.

- **Dynamic Rewards**: Users are rewarded based on the form they complete, with funds automatically deducted from the form's budget.

- **Owner-Based Form Management**: Each form is linked to its respective owner, allowing multiple forms under the same owner.

- **Escrow Retrieval**: Owners can retrieve all forms created under their ownership, including form details such as budget and reward structure.

## Contract Structure

- **FormOwner**: Each form owner can create multiple forms. These forms are stored under the owner and have their own unique `formId`, `uid`.

- **FormItem**: Represents an individual form, with fields such as `budget`, `cost_per_response`, `name`, and time-based `start_date` and `end_date`.

- **createForm**: Allows form owners to create new forms with specified attributes and a unique ID (`formId`, `uid`).

- **reward**: Rewards users based on form completion, transferring the cost per response to the user and deducting it from the form’s budget.

- **getFormsByOwner**: Retrieves all forms under a specific form owner.
