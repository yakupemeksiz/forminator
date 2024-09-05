# Forminator

**Forminator** is a Flutter package that simplifies form management and validation. With customizable form fields, dynamic error handling, and batch validation, it optimizes the form creation process, making it easier and more flexible.

## Features

- Customizable form fields
- Dynamic error management
- Batch validation of form fields
- Hide errors on focus
- Callback for form changes

## Installation

Add **Forminator** to your `pubspec.yaml` file:

```yaml
dependencies:
  forminator: latest_version
```

Then, run the following command:

```bash
flutter pub get
```

## Usage

Here's a basic example of how to use the **Forminator** package:

### Example

```dart
import 'package:flutter/material.dart';
import 'package:forminator/forminator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forminator Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ForminatorState> _formKey = GlobalKey<ForminatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forminator Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Forminator(
          key: _formKey,
          hideErrorOnFocus: true,
          onChanged: () {
            print('Form changed!');
          },
          child: Column(
            children: [
              ForminatorTextFormField(
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              ForminatorTextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.isValid(forceShowError: true)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Form is valid!')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Form has errors!')),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### Explanation

- **Forminator** manages the form, and each field is validated dynamically.
- When the "Submit" button is pressed, the form’s validity is checked, and an appropriate message is displayed using a `SnackBar`.
- **ForminatorTextFormField** is used for each field, with custom validators and error handling.

### Properties of Forminator

- `hideErrorOnFocus`: If `true`, the error messages are hidden when a field is focused.
- `onChanged`: A callback that is triggered when any field in the form changes.

### Properties of ForminatorTextFormField

- `validator`: A function that validates the input text and returns an error message if invalid.
- `obscureText`: Used for password fields to hide the input.
- `decoration`: Adds UI decoration around the text field.
