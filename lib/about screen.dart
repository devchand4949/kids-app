import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  AboutScreen({super.key});

  Future<void> _launchPrivacy() async {
    final Uri _url = Uri.parse('https://sites.google.com/view/human-body-parts-privacy/home');
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $_url');
    }
  }

  Future<void> _launchContactUs() async {
    final Uri _url = Uri.parse('https://newaurainfo.netlify.app/');
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $_url');
    }
  }

  Future<void> _share() async {
    final params = ShareParams(
      text: '''
Human Body Parts (Kids learning app) - Download now:
https://play.google.com/store/apps/details?id=com.com.humanbodyparts.kidslearning.app
''',
      subject: 'Download Human Body Parts App',
    );
    await SharePlus.instance.share(params);
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth > 600;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF04A3B6),
        title: const Text(
          'About Us',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 32.0 : 16.0,
                vertical: isTablet ? 24.0 : 12.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ResponsiveButton(
                    icon: Icons.share,
                    label: "Share App",
                    onPressed: _share,
                    isTablet: isTablet,
                  ),
                  ResponsiveButton(
                    icon: Icons.privacy_tip,
                    label: "Privacy Policy",
                    onPressed: _launchPrivacy,
                    isTablet: isTablet,
                  ),
                  ResponsiveButton(
                    icon: Icons.contact_page,
                    label: "Contact Us",
                    onPressed: _launchContactUs,
                    isTablet: isTablet,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class ResponsiveButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool isTablet;

  const ResponsiveButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    double iconSize = isTablet ? 32 : 24;
    double fontSize = isTablet ? 20 : 16;
    double spacing = isTablet ? 24 : 16;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Material(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            child: Row(
              children: [
                Icon(icon, size: iconSize, color: Colors.teal),
                SizedBox(width: spacing),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(fontSize: fontSize),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


