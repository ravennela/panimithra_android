import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:panimithra/src/presentation/bloc/users_bloc/user_bloc.dart';
import 'package:panimithra/src/presentation/bloc/users_bloc/user_event.dart';
import 'package:panimithra/src/presentation/bloc/users_bloc/user_state.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FetchUsersBloc>().add(const FetchFaqEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FAQs"),
        centerTitle: true,
      ),
      body: BlocBuilder<FetchUsersBloc, FetchUsersState>(
        buildWhen: (previous, current) =>
            current is FaqLoading ||
            current is FaqLoaded ||
            current is FaqError,
        builder: (context, state) {
          if (state is FaqLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is FaqError) {
            return Center(child: Text(state.message));
          }
          if (state is FaqLoaded) {
            if (state.faqList.isEmpty) {
              return const Center(child: Text("No FAQs found"));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: state.faqList.length,
              itemBuilder: (context, index) {
                final faq = state.faqList[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 1.5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ExpansionTile(
                    tilePadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    title: Text(
                      faq.question ?? "",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Text(
                          faq.answer ?? "",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
