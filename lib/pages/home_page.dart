import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _deviceModel = '';
  String _deviceMemory = '';
  String _deviceId = '';

  @override
  void initState() {
    super.initState();
    _getDeviceInfo();
  }

  Future<void> _getDeviceInfo() async {
    try {
      final deviceInfo = DeviceInfoPlugin();

      if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;

        print('Debug - iOS Info:'); // 调试信息
        print('Name: ${iosInfo.name}');
        print('Model: ${iosInfo.model}');
        print('System Name: ${iosInfo.systemName}');
        print('System Version: ${iosInfo.systemVersion}');
        print('Identifier: ${iosInfo.identifierForVendor}');

        setState(() {
          // 设备型号，例如："iPhone"
          _deviceModel = iosInfo.name ?? '未知型号';
          // 暂时写死内存规格，后续根据实际情况获取
          _deviceMemory = '4GB+256GB';
          // 设备唯一标识符
          _deviceId = iosInfo.identifierForVendor ?? '未知串码';
        });
      } else if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;

        print('Debug - Android Info:'); // 调试信息
        print('Model: ${androidInfo.model}');
        print('Brand: ${androidInfo.brand}');
        print('Device: ${androidInfo.device}');
        print('ID: ${androidInfo.id}');

        setState(() {
          _deviceModel = androidInfo.model;
          _deviceMemory = '获取中...';
          _deviceId = androidInfo.id;
        });
      }
    } catch (e, stackTrace) {
      print('Error getting device info: $e');
      print('Stack trace: $stackTrace');

      setState(() {
        _deviceModel = '获取失败';
        _deviceMemory = '获取失败';
        _deviceId = '获取失败';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/bg.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              const Color(0xFF1F1F2E).withOpacity(0.85),
              BlendMode.srcOver,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  '机海验机',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _deviceModel,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 20,
                        runSpacing: 8,
                        children: [
                          Text(
                            '内存：$_deviceMemory',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '串码：$_deviceId',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Center(
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Image(
                        image: AssetImage('assets/qr_code.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    '扫码获取质检权限',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
