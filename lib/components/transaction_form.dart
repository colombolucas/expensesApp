import 'dart:html';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/message_format.dart';
import 'package:intl/number_symbols_data.dart';
import 'transaction_list.dart';
import 'package:intl/intl.dart';

class TransactionForm extends StatefulWidget {
  final void Function(String, double, DateTime) onSubmit;
  TransactionForm(this.onSubmit);

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _titleController = TextEditingController();
  final _valueController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  _submitForm() {
    final title = _titleController.text;
    final value =
        double.tryParse(_valueController.text.replaceAll(",", ".")) ?? 0.0;

    if (value <= 0 || value.isNaN || value >= 100000.0) {
      //Navigator.of(context).pop();

      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Preenchimento dos campos obrigatórios'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('Os seguintes campos precisam ser preenchidos:'),
                  Text(
                    "Valor (R\$)",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Text('Inserir algum valor, por exemplo: 22,50.'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'Continuar',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    if (title.isEmpty ||
        title.length > 50 ||
        title.length == 1 ||
        title.contains("1") ||
        title.contains("2") ||
        title.contains("3") ||
        title.contains("4") ||
        title.contains("5") ||
        title.contains("6") ||
        title.contains("7") ||
        title.contains("8") ||
        title.contains("9") ||
        title.contains("@") ||
        title.contains("!") ||
        title.contains("^") ||
        title.contains("~") ||
        title.contains("}") ||
        title.contains(")") ||
        _selectedDate == null) {
      //Navigator.of(context).pop();

      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Preenchimento dos campos obrigatórios'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('Os seguintes campos precisam ser preenchidos:'),
                  Text(
                    "Título",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Text('Inserir algum nome, por exemplo: Conta de Luz.'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  'Continuar',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    widget.onSubmit(title, value, _selectedDate);
  }

  _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  bool throwError = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.only(
            top: 10,
            right: 10,
            left: 10,
            bottom: 10 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: [
              TextField(
                autofocus: true,
                controller: _titleController,
                onSubmitted: (_) => _submitForm(),
                decoration: InputDecoration(labelText: 'Título'),
              ),
              TextField(
                controller: _valueController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onSubmitted: (_) => _submitForm(),
                decoration: InputDecoration(labelText: 'Valor (R\$)'),
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'Nenhum data selecionada!'
                            : 'Data Selecionada: ${DateFormat('dd/MM/y').format(_selectedDate)}',
                        style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      onPressed: _showDatePicker,
                      child: Text(
                        "Selecionar Data",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RaisedButton(
                    onPressed: _submitForm,
                    color: Theme.of(context).colorScheme.primary,
                    child: Text(
                      'Nova Transação',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
