import 'dart:io';
import 'package:credit_card_validator/validation_results.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:credit_card_validator/credit_card_validator.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

import '../../hive/ID.dart';
import '../../hive/boxes.dart';
import '../../input_formatters/card_month_input_formatter.dart';

class AddIdPage extends StatefulWidget {
  const AddIdPage({super.key});

  @override
  State<AddIdPage> createState() => _AddIdPageState();
}

class _AddIdPageState extends State<AddIdPage> {
  final ImagePicker picker = ImagePicker();

  List<String> savedBannedCountryCodes = <String>[];
  final _addCardFormKey = GlobalKey<FormState>();
  String cardTypePath = '';

  //Controllers
  TextEditingController cardHolderNameController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController DateOfBirthController = TextEditingController();
  TextEditingController ExpiryDateController = TextEditingController();
  TextEditingController AddressDateController = TextEditingController();
  final CreditCardValidator _ccValidator = CreditCardValidator();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _addCardFormKey,
          child: Column(
            children: <Widget>[
              buildName(),
              buildCardNumber(),
              buildAddress(),
              Row(
                children: [
                  Expanded(
                    child: buildDateOfBirth(),
                  ),
                  Expanded(
                    child: buildExpiryDate(),
                  ),
                ],
              ),
              buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCardNumber() => Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        child: TextFormField(
          controller: cardNumberController,
          onChanged: (value) {
            if (value.length > 4) return;
          },
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Card Number',
            border: OutlineInputBorder(),
            icon: SizedBox(
              width: 23,
              child: Icon(Icons.credit_card),
            ),
          ),
          maxLength: 19,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(19),
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please Enter Number on Card';
            }
            if (_ccValidator.validateCCNum(value).isValid) {
              return 'Credit Card Number is invalid';
            }
            return null;
          },
        ),
      );

  Widget buildExpiryDate() => Container(
      padding: const EdgeInsets.only(left: 10),
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: TextFormField(
        controller: ExpiryDateController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: 'Expiry Date',
          hintText: '12/26',
          border: OutlineInputBorder(),
          icon: SizedBox(
            // width: 25,
            child: Icon(Icons.date_range),
          ),
        ),
        maxLength: 5,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          CardMonthInputFormatter()
        ],
        validator: (value) {
          ValidationResults datavalidator =
              _ccValidator.validateExpDate(value!);
          if (value.length < 2) {
            return 'Invalid Date';
          }
          if (!datavalidator.isValid) {
            return 'Date is invalid';
          }
          return null;
        },
      ));

  Widget buildSubmitButton() {
    return Container(
      width: 400,
      margin: const EdgeInsets.all(10),
      child: ElevatedButton(
        onPressed: () {
          submit();
        },
        child: const Text(
          'submit',
          style: TextStyle(fontSize: 15),
        ),
      ),
    );
  }

  Widget buildName() => Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: TextFormField(
        controller: cardHolderNameController,
        keyboardType: TextInputType.name,
        decoration: const InputDecoration(
          labelText: 'Name of Id Card ',
          border: OutlineInputBorder(),
          icon: SizedBox(
            width: 23,
            child: Icon(Icons.person),
          ),
        ),
        maxLength: 50,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[A-Za-zا-ي\s]'))
        ],
        validator: (value) {
          if (value == null || value.length < 2) {
            return 'Name must contain at least 2 digits';
          }
          return null;
        },
      ));

  Widget buildAddress() => Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: TextFormField(
        controller: AddressDateController,
        keyboardType: TextInputType.name,
        decoration: const InputDecoration(
          labelText: 'Address ',
          border: OutlineInputBorder(),
          icon: SizedBox(
            width: 23,
            child: Icon(Icons.location_on),
          ),
        ),
        maxLength: 50,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[A-Za-zأ-ي\s]'))
        ],
        validator: (value) {
          if (value == null || value.length < 10) {
            return 'address must contain at least 10 digits';
          }
          return null;
        },
      ));

  Widget buildDateOfBirth() => Container(
      padding: const EdgeInsets.only(left: 10),
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: TextFormField(
        controller: DateOfBirthController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: 'DateOfBirth',
          border: OutlineInputBorder(),
          icon: SizedBox(
            // width: 25,
            child: Icon(Icons.date_range),
          ),
        ),
        maxLength: 5,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          CardMonthInputFormatter()
        ],
        validator: (value) {
          ValidationResults datavalidator =
              _ccValidator.validateExpDate(value!);
          if (value.length < 2) {
            return 'Invalid Date';
          }
          if (datavalidator.isValid) {
            return 'Date is invalid';
          }
          return null;
        },
      ));

  Future scan() async {
    _addCardFormKey.currentState!.reset();
    await showDialoguePrompt(
        instructionText: 'Please scan front of card', onPress: autoFillFields);
    await showDialoguePrompt(
        instructionText: 'Please scan back of card', onPress: autoFillFields);
  }

  Future<void> autoFillFields() async {
    final image = await picker.pickImage(source: ImageSource.camera);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    if (image != null) {
      final imagePath = File(image.path);
      final inputImage = InputImage.fromFile(imagePath);
      final RecognizedText recognizedText =
          await textRecognizer.processImage(inputImage);
      for (TextBlock block in recognizedText.blocks) {
        final String text = block.text;

        if (text.startsWith(RegExp('([0-9])')) &&
            text.length > 13 &&
            text.length < 20) {}
        if (text.length == 5 && text.contains('/')) {
          //checks date fromat
          ExpiryDateController.text = text;
        }
        if (num.tryParse(text) != null && //checks if string is a number
            text.length >= 3 &&
            text.length < 5) {
          DateOfBirthController.text = text;
        }
      }
    }
    textRecognizer.close();
  }

  Future<void> showDialoguePrompt(
      {required String instructionText, required Function onPress}) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shadowColor: Colors.blueAccent,
        title: Text(
          instructionText,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => {onPress(), Navigator.pop(context, 'OK')},
            child: const Text('OK'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  submit() {
    bool? isValid = _addCardFormKey.currentState?.validate();
    bool? cardExists = boxId.containsKey(cardNumberController.text);
    if (cardExists) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          shadowColor: Colors.blueAccent,
          title: const Text(
            'Card Number already exists',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Please add card card with a different number',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
    if (isValid != null && isValid && !cardExists) {
      Id newCard = Id(
        cardNumber: cardNumberController.text,
        ExpiryDate: ExpiryDateController.text,
        cardHolderName: cardHolderNameController.text,
        DateOfBirth: DateOfBirthController.text,
        Addres: AddressDateController.text,
        cardType: cardNumberController.text,
      );
      setState(() {
        boxId
            .put(cardNumberController.text, newCard)
            .then((value) => Navigator.pop(context));
      });
    }
  }
}
