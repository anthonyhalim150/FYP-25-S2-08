import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  Widget sectionTitle(String text) => Padding(
        padding: const EdgeInsets.only(top: 24, bottom: 8),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 19,
            color: Colors.deepPurple,
          ),
        ),
      );

  Widget bulletList(List<String> items) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(left: 6.0, bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("• ", style: TextStyle(fontSize: 15.5)),
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(fontSize: 15.5),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      );

  List<String> getBulletList(BuildContext context, String key) {
    final value = tr(key, context: context);
    if (value.trim().isEmpty) {
      return [];
    }
    return value.split('\n').map((e) => e.trim()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('privacy_policy_title'.tr()),
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'privacy_policy_title'.tr(),
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'privacy_policy_effective_date'.tr(),
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 18),
              Text(
                'privacy_policy_intro'.tr(),
                style: const TextStyle(fontSize: 15.5),
              ),

              // SECTION 1
              sectionTitle('privacy_policy_section1'.tr()),
              const SizedBox(height: 4),
              Text(
                'privacy_policy_1a'.tr(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.5,
                ),
              ),
              bulletList(getBulletList(context, 'privacy_policy_1a_bullets')),
              const SizedBox(height: 7),
              Text(
                'privacy_policy_1b'.tr(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.5,
                ),
              ),
              bulletList(getBulletList(context, 'privacy_policy_1b_bullets')),
              const SizedBox(height: 7),
              Text(
                'privacy_policy_1c'.tr(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Text(
                  'privacy_policy_1c_text'.tr(),
                  style: const TextStyle(fontSize: 15.5),
                ),
              ),

              // SECTION 2
              sectionTitle('privacy_policy_section2'.tr()),
              bulletList(getBulletList(context, 'privacy_policy_2_bullets')),

              // SECTION 3
              sectionTitle('privacy_policy_section3'.tr()),
              bulletList(getBulletList(context, 'privacy_policy_3_bullets')),
              Padding(
                padding: const EdgeInsets.only(left: 6, top: 4),
                child: Text(
                  'privacy_policy_3_text'.tr(),
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              // SECTION 4
              sectionTitle('privacy_policy_section4'.tr()),
              Padding(
                padding: const EdgeInsets.only(left: 6.0, bottom: 6),
                child: Text(
                  'privacy_policy_4_text'.tr(),
                  style: const TextStyle(fontSize: 15.5),
                ),
              ),

              // SECTION 5
              sectionTitle('privacy_policy_section5'.tr()),
              bulletList(getBulletList(context, 'privacy_policy_5_bullets')),

              // SECTION 6
              sectionTitle('privacy_policy_section6'.tr()),
              Padding(
                padding: const EdgeInsets.only(left: 6.0, bottom: 6),
                child: Text(
                  'privacy_policy_6_text'.tr(),
                  style: const TextStyle(fontSize: 15.5),
                ),
              ),

              // SECTION 7
              sectionTitle('privacy_policy_section7'.tr()),
              Padding(
                padding: const EdgeInsets.only(left: 6.0, bottom: 6),
                child: Text(
                  'privacy_policy_7_text'.tr(),
                  style: const TextStyle(fontSize: 15.5),
                ),
              ),

              // SECTION 8
              sectionTitle('privacy_policy_section8'.tr()),
              Padding(
                padding: const EdgeInsets.only(left: 6.0, bottom: 18),
                child: Text(
                  'privacy_policy_8_text'.tr(),
                  style: const TextStyle(fontSize: 15.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}