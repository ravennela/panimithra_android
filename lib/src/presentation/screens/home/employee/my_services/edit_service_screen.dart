import 'package:flutter/material.dart';

class EditServiceScreen extends StatefulWidget {
  final String serviceId;
  const EditServiceScreen({super.key, required this.serviceId});

  @override
  State<StatefulWidget> createState() {
    return EditServiceScreenWidget();
  }
}

class EditServiceScreenWidget extends State<EditServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Service',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: const SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Fill in the details below to list a new service.',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                SizedBox(height: 20),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
