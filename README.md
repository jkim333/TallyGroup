# Tally Group Code Challenge

## Live website

https://tally-group-coding-challenge.herokuapp.com/

<br/>

## Instruction

Please follow the steps below to install and run the application.

1. Clone this repository to your computer and change directory into the project folder.

```
git clone git@github.com:jkim333/TallyGroup.git
cd TallyGroup
```

2. Install the dependencies.

```
bundle
```

3. Test the application.

```
rspec
```

4. Run the application.

```
rails s
```

<br/>

## Lambda function:

Amazon API Gateway, Lambda function, and Python programming language were used to solve the challenge. Below is the code snippet.

```py
import json
from pulp import *

def lambda_handler(event, context):
    body = json.loads(event['body'])
    filtered_items = body['filtered_items']
    number = body['number']

    problem = LpProblem('Bakery', LpMinimize)

    items = [
        {
            'id': item['id'],
            'name': item['name'],
            'code': item['code'],
            'pack_number': item['pack_number'],
            'pack_price': item['pack_price'],
            'decision_variable': LpVariable(
                f"{item['pack_number']}_@_${item['pack_price']/100}",
                lowBound=0, cat=LpInteger
            ),
        }
        for item in filtered_items
    ]

    # Objective function & constraint equation
    objective_function = None
    constraint_equation = None
    for item in items:
        objective_function += item['decision_variable']
        constraint_equation += item['pack_number'] * item['decision_variable']

    problem += objective_function
    problem += constraint_equation == number

    # Solve the problem
    problem.solve()

    # Return status 422 if the problem cannot be solved
    if LpStatus[problem.status] != 'Optimal':
        return {
            'statusCode': 422,
            'body': 'The problem could not be solved. Please try again with different input.'
        }

    # Create response list
    response = []
    for item in items:
        response.append(
            {
                'id': item['id'],
                'name': item['name'],
                'code': item['code'],
                'pack_number': item['pack_number'],
                'pack_price': item['pack_price'],
                'quantity': item['decision_variable'].varValue
            }
        )

    return {
        'statusCode': 200,
        'body': json.dumps(response)
    }
```
