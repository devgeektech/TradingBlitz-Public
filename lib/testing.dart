// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:linkedin_login/linkedin_login.dart';
//
// String redirectUrl = 'https://tradingblitz.com/accounts/oidc/linkedin-server/login/callback/';
// String clientId = '782ac2v88p83fd';
// String clientSecret = 'LvJDgFYDuZmEs58x';
// final List<Scope> scopes = [
//   EmailScope(),
//   OpenIdScope(),
//   ProfileScope()
// ];
//
// class LinkedInProfileExamplePage extends StatefulWidget {
//   const LinkedInProfileExamplePage({super.key});
//
//   @override
//   State createState() => _LinkedInProfileExamplePageState();
// }
//
// class _LinkedInProfileExamplePageState extends State<LinkedInProfileExamplePage> {
//   UserObject? user;
//   bool logoutUser = false;
//
//   @override
//   Widget build(final BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: <Widget>[
//           LinkedInButtonStandardWidget(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute<void>(
//                     builder: (BuildContext context) => LinkedInUserWidget(
//                       appBar: AppBar(title: const Text('OAuth User')),
//                       destroySession: logoutUser,
//                       redirectUrl: redirectUrl,
//                       clientId: clientId,
//                       clientSecret: clientSecret,
//                       scope: scopes, // ✅ correct for v3.1.3
//                       onError: (UserFailedAction e) {
//                         debugPrint('Error: ${e.toString()}');
//                       },
//                       onGetUserProfile: (UserSucceededAction linkedInUser) {
//                         final accessToken = linkedInUser.user.token.accessToken;
//                         debugPrint('✅ Access Token: $accessToken');
//
//                         user = UserObject(
//                           firstName: linkedInUser.user.givenName,
//                           lastName: linkedInUser.user.familyName,
//                           email: linkedInUser.user.email,
//                           profileImageUrl: linkedInUser.user.picture,
//                         );
//
//                         setState(() {
//                           validateLinkedInAccessToken(accessToken!);
//                           logoutUser = false;
//                         });
//
//                         Navigator.pop(context);
//                       },
//                     )
//
//                   ),
//                 );
//               }
//
//           ),
//           LinkedInButtonStandardWidget(
//             onTap: () {
//               setState(() {
//                 user = null;
//                 logoutUser = true;
//               });
//             },
//             buttonText: 'Logout',
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Text('First: ${user?.firstName} '),
//               Text('Last: ${user?.lastName} '),
//               Text('Email: ${user?.email}'),
//               Text('Profile image: ${user?.profileImageUrl}'),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//
//
//   Future<void> validateLinkedInAccessToken(String accessToken) async {
//     final Uri userInfoUrl = Uri.parse('https://api.linkedin.com/v2/me');
//
//     try {
//       final response = await http.get(
//         userInfoUrl,
//         headers: {
//           'Authorization': 'Bearer $accessToken',
//           'Connection': 'Keep-Alive',
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         debugPrint('✅ LinkedIn Token is valid.');
//         debugPrint('👤 User Info:');
//         debugPrint('ID: ${data['id']}');
//         debugPrint('First Name: ${data['localizedFirstName']}');
//         debugPrint('Last Name: ${data['localizedLastName']}');
//       } else {
//         debugPrint('❌ Token may be invalid or expired.');
//         debugPrint('Status Code: ${response.statusCode}');
//         debugPrint('Response Body: ${response.body}');
//       }
//     } catch (e) {
//       debugPrint('❌ Error occurred while validating token: $e');
//     }
//   }
//
//
// }
//
// class LinkedInAuthCodeExamplePage extends StatefulWidget {
//   const LinkedInAuthCodeExamplePage({super.key});
//
//   @override
//   State createState() => _LinkedInAuthCodeExamplePageState();
// }
//
// class _LinkedInAuthCodeExamplePageState extends State<LinkedInAuthCodeExamplePage> {
//   AuthCodeObject? authorizationCode;
//   bool logoutUser = false;
//
//   @override
//   Widget build(final BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: <Widget>[
//         LinkedInButtonStandardWidget(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute<void>(
//                 builder: (final BuildContext context) => LinkedInAuthCodeWidget(
//                   destroySession: logoutUser,
//                   redirectUrl: redirectUrl,
//                   clientId: clientId,
//                   onError: (final AuthorizationFailedAction e) {
//                     debugPrint('Error: ${e.toString()}');
//                     debugPrint('Error: ${e.stackTrace.toString()}');
//                   },
//                   onGetAuthCode: (final AuthorizationSucceededAction response) {
//                     debugPrint('Auth code ${response.codeResponse.code}');
//
//                     debugPrint('State: ${response.codeResponse.state}');
//
//                     authorizationCode = AuthCodeObject(
//                       code: response.codeResponse.code,
//                       state: response.codeResponse.state,
//                     );
//                     setState(() {});
//
//                     Navigator.pop(context);
//                   },
//                 ),
//                 fullscreenDialog: true,
//               ),
//             );
//           },
//         ),
//         LinkedInButtonStandardWidget(
//           onTap: () {
//             setState(() {
//               authorizationCode = null;
//               logoutUser = true;
//             });
//           },
//           buttonText: 'Logout user',
//         ),
//         Container(
//           margin: const EdgeInsets.symmetric(horizontal: 16),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Text('Auth code: ${authorizationCode?.code} '),
//               Text('State: ${authorizationCode?.state} '),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class AuthCodeObject {AuthCodeObject({required this.code, required this.state});
//
//   final String? code;
//   final String? state;
// }
//
// class UserObject {
//   UserObject({
//     required this.firstName,
//     required this.lastName,
//     required this.email,
//     required this.profileImageUrl,
//   });
//
//   final String? firstName;
//   final String? lastName;
//   final String? email;
//   final String? profileImageUrl;
// }

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:trading/utils/theme.dart';
import 'package:trading/utils/utils.dart';
import 'package:trading/widget/commontext.dart';

class DataPoint {
  final DateTime date;
  final double value;

  DataPoint({required this.date, required this.value});

  factory DataPoint.fromJson(Map<String, dynamic> json) {
    return DataPoint(
      date: DateTime.parse(json['date']),
      value: json['value'],
    );
  }
}



class LineChartWidget extends StatelessWidget {
  final List<DataPoint> data;

  const LineChartWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final bool isEmpty = data.isEmpty;

    final List<DataPoint> displayData = isEmpty
        ? [DataPoint(date: DateTime.now(), value: 0)]
        : data;

    double minX = 0;
    double maxX = displayData.length <= 1 ? 1 : displayData.length.toDouble() - 1;

    double minY = displayData.map((e) => e.value).reduce((a, b) => a < b ? a : b);
    double maxY = displayData.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    double intervalVertical = (displayData.length / 10).ceilToDouble();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 1.8.w, vertical: 1.8.h),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.black12
            : const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [


          Padding(
            padding: const EdgeInsets.only(left: 5.0, bottom: 10.0),
            child: CommonTextWidget(
              heading: "Overall Performance",
              fontSize: Utils.responsiveFontSize(context, 16.sp),
              fontWeight: FontWeight.bold,
              color: ThemeProvider.whiteColor,
            ),
          ),

          AspectRatio(
            aspectRatio: 2.1,
            child: Stack(
              alignment: Alignment.center,
              children: [
                LineChart(
                  LineChartData(
                    minX: minX,
                    maxX: maxX,
                    minY: minY,
                    maxY: maxY,
                    lineBarsData: [
                      LineChartBarData(
                        spots: displayData
                            .asMap()
                            .entries
                            .map((e) => FlSpot(
                            e.key.toDouble(), e.value.value))
                            .toList(),
                        isCurved: true,
                        color: Colors.blue,
                        barWidth: 2,
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.blue.withOpacity(0.2),
                        ),
                        dotData: FlDotData(show: !isEmpty),
                      ),
                    ],
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          reservedSize: 40,
                          showTitles: true,
                          interval: intervalVertical,
                          getTitlesWidget: (value, meta) {
                            final index = value.round();
                            if (index < 0 || index >= displayData.length) {
                              return const SizedBox.shrink();
                            }

                            final point = displayData[index];
                            final dt = point.date;

                            return Transform.rotate(
                              angle: -0.7854,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 6),
                                  CommonTextWidget(
                                    heading:
                                    DateFormat('d MMM').format(dt),
                                    fontSize: 10,
                                    color: Colors.white70,
                                  ),
                                  CommonTextWidget(
                                    heading:
                                    DateFormat('HH:mm').format(dt),
                                    fontSize: 10,
                                    color: Colors.white70,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          // interval: 1,
                          getTitlesWidget: (value, meta) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 6.0),
                              child: Text(
                                value.toStringAsFixed(0),
                                style: TextStyle(
                                  fontSize:
                                  Utils.responsiveFontSize(context, 10.sp),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Urbanist",
                                  decoration: TextDecoration.none,
                                  color: ThemeProvider.whiteColor,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      topTitles: AxisTitles(),
                      rightTitles: AxisTitles(),
                    ),
                    lineTouchData: LineTouchData(
                      enabled: !isEmpty,
                      touchTooltipData: LineTouchTooltipData(
                        tooltipRoundedRadius: 12,
                        fitInsideHorizontally: true,
                        fitInsideVertically: true,
                        maxContentWidth: 150,
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((spot) {
                            final index = spot.x.toInt();
                            if (index < 0 || index >= displayData.length) {
                              return null;
                            }

                            final point = displayData[index];
                            final date =
                            DateFormat('d MMM HH:mm').format(point.date);
                            final value = point.value.toStringAsFixed(2);

                            return LineTooltipItem(
                              '$date\n',
                              TextStyle(
                                fontSize: Utils.responsiveFontSize(
                                    context, 12.sp),
                                fontWeight: FontWeight.w500,
                                fontFamily: "Urbanist",
                                color: ThemeProvider.textColor,
                                decoration: TextDecoration.none,
                              ),
                              children: [
                                TextSpan(
                                  text: '₹ $value',
                                  style: TextStyle(
                                    fontSize: Utils.responsiveFontSize(
                                        context, 12.sp),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Urbanist",
                                    decoration: TextDecoration.none,
                                    color: ThemeProvider.textColor,
                                  ),
                                ),
                              ],
                            );
                          }).toList();
                        },
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawHorizontalLine: true,
                      drawVerticalLine: true,
                    ),
                    extraLinesData: ExtraLinesData(
                      verticalLines: [
                        VerticalLine(
                          x: 0,
                          color: Colors.grey.withOpacity(0.3),
                          strokeWidth: 1,
                          dashArray: [4, 2],
                        ),
                        VerticalLine(
                          x: displayData.length.toDouble() - 1,
                          color: Colors.grey.withOpacity(0.3),
                          strokeWidth: 1,
                          dashArray: [4, 2],
                        ),
                      ],
                      horizontalLines: [
                        HorizontalLine(
                          y: 0,
                          color: Colors.grey.withOpacity(0.3),
                          strokeWidth: 1,
                          dashArray: [4, 2],
                        ),


                        HorizontalLine(
                          y: 0,
                          color: Colors.grey.withOpacity(0.5),
                          strokeWidth: 1.5,
                        ),


                      ],
                    ),

                    borderData: FlBorderData(show: false),
                  ),
                ),
                if (isEmpty)
                  Positioned.fill(
                    top: -30.sp,
                    left: 20.sp,
                    child: Center(
                      child: Text(
                        "No data available",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
