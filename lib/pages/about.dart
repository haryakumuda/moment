import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:moment/util/my_colors.dart';
import 'package:package_info_plus/package_info_plus.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background,
      appBar: AppBar(
        title: Text(
          "About",
          style: TextStyle(color: MyColors.textMain),
        ),
        backgroundColor: MyColors.appBar,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "${_packageInfo.appName}",
                style: TextStyle(color: MyColors.textMain),
              ),
              Text(
                "Version: ${_packageInfo.version}",
                style: TextStyle(color: MyColors.textMain),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Thanks for your support!",
                style: TextStyle(color: MyColors.textMain),
              ),
              Text(
                "Developed by @haryakumuda",
                style: TextStyle(color: MyColors.textMain),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
