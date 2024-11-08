import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:quitsmoke/screens/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {


  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {


  String name = '';
  String country = '';
  String city = '';
  bool agreedToTerms = false;
  TextEditingController countryController=TextEditingController();
  TextEditingController nameController=TextEditingController();
  TextEditingController cityController=TextEditingController();
  _donavigate() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool("register") != null) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => SplashScreen()));
    }
  }

  @override
  void initState() {
    super.initState();
    _donavigate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/logo.jpeg",height: 300,width: 300,)
              ],
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Name',
              ),
              onChanged: (value) {
                setState(() {
                  nameController.text = value;
                });
              },
            ),
            GestureDetector(
              onTap: (){
                showCountryPicker(
                  context: context,
                  showPhoneCode: true, // optional. Shows phone code before the country name.
                  onSelect: (Country country) {
                    print('Select country: ${country.displayName}');
                    countryController.text=country.name;
                  },
                );
              },
              child: TextFormField(
                controller: countryController,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Country',
                ),
                onChanged: (value) {
                  setState(() {
                    country = value;
                  });
                },
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'City',
              ),
              onChanged: (value) {
                setState(() {
                  cityController.text = value;
                });
              },
            ),
            Row(
              children: [
                Checkbox(
                  value: agreedToTerms,
                  onChanged: (value) {
                    setState(() {
                      agreedToTerms = value ?? false;
                    });
                  },
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      showTermsPopup(context);
                    },
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Agree to ',
                            style: TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                            text: 'terms and conditions',
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: agreedToTerms ? _addUser : null,
                  child: Text('Register'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
  Future<void> _addUser() async {
    try {
      // Add user information to Firestore
      await FirebaseFirestore.instance.collection('users').add({
        'name': nameController.text,
        'country': countryController.text,
        'city': cityController.text,
        'joinDate': FieldValue.serverTimestamp(),
      });

      // Show success message to the user
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('User added successfully'),
      ));

print(" my name ${nameController.text}");
      SharedPreferences pref = await SharedPreferences.getInstance();
      Future.delayed(Duration(seconds: 5), () {
        pref.setBool("register", true);
        pref.setString("userName", nameController.text);
        pref.setString("userCountry", countryController.text);
        pref.setString("userCity", cityController.text);
        
      }).then((value){
        nameController.clear();
        countryController.clear();
        cityController.clear();
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => SplashScreen()));
      });
      // Clear form fields after submission


    } catch (e) {
      // Handle errors
      print('Error adding user: $e');
      // Show error message to the user
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to add user: $e'),
      ));
    }
  }
  void signUp() {
    // Perform signup logic here
    print('Name: $name');
    print('Country: ${countryController.text}');
    print('City: $city');
    print('Agreed to terms: $agreedToTerms');
    // You can add more logic here, such as sending data to a server
  }

  void showTermsPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Terms and Conditions'),
          content: SingleChildScrollView(
            child: Text(
              '''
              Welcome to Smoke Free!
These terms and conditions outline the rules and regulations for the use of Smoke Free.
By using this app we assume you accept these terms and conditions. Do not continue to use Smoke Free if you do not agree to take all of the terms and conditions stated on this page.
The following terminology applies to these Terms and Conditions, Privacy Statement and Disclaimer Notice and all Agreements: "Client", "You" and "Your" refers to you, the person log on this website and compliant to the Company's terms and conditions. "The Company", "Ourselves", "We", "Our" and "Us", refers to our Company. "Party", "Parties", or "Us", refers to both the Client and ourselves. All terms refer to the offer, acceptance and consideration of payment necessary to undertake the process of our assistance to the Client in the most appropriate manner for the express purpose of meeting the Client's needs in respect of provision of the Company's stated services, in accordance with and subject to, prevailing law of bd. Any use of the above terminology or other words in the singular, plural, capitalization and/or he/she or they, are taken as interchangeable and therefore as referring to same. Our Terms and Conditions were created with the help of the App Terms and Conditions Generator
License
Unless otherwise stated, Smoke Free and/or its licensors own the intellectual property rights for all material on Smoke Free. All intellectual property rights are reserved. You may access this from Smoke Free for your own personal use subjected to restrictions set in these terms and conditions.
You must not:
Republish material from Smoke Free
Sell, rent or sub-license material from Smoke Free
Reproduce, duplicate or copy material from Smoke Free
Redistribute content from Smoke Free
This Agreement shall begin on the date hereof.
Parts of this app offer an opportunity for users to post and exchange opinions and information in certain areas of the website. Smoke Free does not filter, edit, publish or review Comments prior to their presence on the website. Comments do not reflect the views and opinions of Smoke Free, its agents and/or affiliates. Comments reflect the views and opinions of the person who post their views and opinions. To the extent permitted by applicable laws, Smoke Free shall not be liable for the Comments or for any liability, damages or expenses caused and/or suffered as a result of any use of and/or posting of and/or appearance of the Comments on this website.
Smoke Free reserves the right to monitor all Comments and to remove any Comments which can be considered inappropriate, offensive or causes breach of these Terms and Conditions.
You warrant and represent that:
You are entitled to post the Comments on our App and have all necessary licenses and consents to do so;
The Comments do not invade any intellectual property right, including without limitation copyright, patent or trademark of any third party;
The Comments do not contain any defamatory, libelous, offensive, indecent or otherwise unlawful material which is an invasion of privacy
The Comments will not be used to solicit or promote business or custom or present commercial activities or unlawful activity.
You hereby grant Smoke Free a non-exclusive license to use, reproduce, edit and authorize others to use, reproduce and edit any of your Comments in any and all forms, formats or media.
Hyperlinking to our App
The following organizations may link to our App without prior written approval:
Government agencies;
Search engines;
News organizations;
Online directory distributors may link to our App in the same manner as they hyperlink to the Websites of other listed businesses; and
System wide Accredited Businesses except soliciting non-profit organizations, charity shopping malls, and charity fundraising groups which may not hyperlink to our Web site.
These organizations may link to our home page, to publications or to other App information so long as the link: (a) is not in any way deceptive; (b) does not falsely imply sponsorship, endorsement or approval of the linking party and its products and/or services; and (c) fits within the context of the linking party's site.
We may consider and approve other link requests from the following types of organizations:
commonly-known consumer and/or business information sources;
dot.com community sites;
associations or other groups representing charities;
online directory distributors;
internet portals;
accounting, law and consulting firms; and
educational institutions and trade associations.
We will approve link requests from these organizations if we decide that: (a) the link would not make us look unfavorably to ourselves or to our accredited businesses; (b) the organization does not have any negative records with us; (c) the benefit to us from the visibility of the hyperlink compensates the absence of Smoke Free; and (d) the link is in the context of general resource information.
These organizations may link to our App so long as the link: (a) is not in any way deceptive; (b) does not falsely imply sponsorship, endorsement or approval of the linking party and its products or services; and (c) fits within the context of the linking party's site.
If you are one of the organizations listed in paragraph 2 above and are interested in linking to our App, you must inform us by sending an e-mail to Smoke Free. Please include your name, your organization name, contact information as well as the URL of your site, a list of any URLs from which you intend to link to our App, and a list of the URLs on our site to which you would like to link. Wait 2-3 weeks for a response.
Approved organizations may hyperlink to our App as follows:
By use of our corporate name; or
By use of the uniform resource locator being linked to; or
By use of any other description of our App being linked to that makes sense within the context and format of content on the linking party's site.
No use of Smoke Free's logo or other artwork will be allowed for linking absent a trademark license agreement.
iFrames
Without prior approval and written permission, you may not create frames around our Webpages that alter in any way the visual presentation or appearance of our App.
Content Liability
We shall not be hold responsible for any content that appears on your App. You agree to protect and defend us against all claims that is rising on our App. No link(s) should appear on any Website that may be interpreted as libelous, obscene or criminal, or which infringes, otherwise violates, or advocates the infringement or other violation of, any third party rights.
Reservation of Rights
We reserve the right to request that you remove all links or any particular link to our App. You approve to immediately remove all links to our App upon request. We also reserve the right to amen these terms and conditions and it's linking policy at any time. By continuously linking to our App, you agree to be bound to and follow these linking terms and conditions.
Removal of links from our App
If you find any link on our App that is offensive for any reason, you are free to contact and inform us any moment. We will consider requests to remove links but we are not obligated to or so or to respond to you directly.
We do not ensure that the information on this website is correct, we do not warrant its completeness or accuracy; nor do we promise to ensure that the website remains available or that the material on the website is kept up to date.
Disclaimer
To the maximum extent permitted by applicable law, we exclude all representations, warranties and conditions relating to our App and the use of this website. Nothing in this disclaimer will:
limit or exclude our or your liability for death or personal injury;
limit or exclude our or your liability for fraud or fraudulent misrepresentation;
limit any of our or your liabilities in any way that is not permitted under applicable law; or
exclude any of our or your liabilities that may not be excluded under applicable law.
The limitations and prohibitions of liability set in this Section and elsewhere in this disclaimer: (a) are subject to the preceding paragraph; and (b) govern all liabilities arising under the disclaimer, including liabilities arising in contract, in tort and for breach of statutory duty.
As long as the website and the information and services on the website are provided free of charge, we will not be liable for any loss or damage of any nature.

Privacy Policy for Smoke Free
At Smoke Free, one of our main priorities is the privacy of our visitors. This Privacy Policy document contains types of information that is collected and recorded by Smoke Free and how we use it.
If you have additional questions or require more information about our Privacy Policy, do not hesitate to contact us.
Log Files
Smoke Free follows a standard procedure of using log files. These files log visitors when they use app. The information collected by log files include internet protocol (IP) addresses, browser type, Internet Service Provider (ISP), date and time stamp, referring/exit pages, and possibly the number of clicks. These are not linked to any information that is personally identifiable. The purpose of the information is for analyzing trends, administering the app, tracking users' movement on the app, and gathering demographic information.
Our Advertising Partners
Some of advertisers in our app may use cookies and web beacons. Our advertising partners are listed below. Each of our advertising partners has their own Privacy Policy for their policies on user data. For easier access, we hyperlinked to their Privacy Policies below.
Google
https://policies.google.com/technologies/ads
Privacy Policies
You may consult this list to find the Privacy Policy for each of the advertising partners of Smoke Free.
Third-party ad servers or ad networks uses technologies like cookies, JavaScript, or Beacons that are used in their respective advertisements and links that appear on Smoke Free. They automatically receive your IP address when this occurs. These technologies are used to measure the effectiveness of their advertising campaigns and/or to personalize the advertising content that you see on this app or other apps or websites.
Note that Smoke Free has no access to or control over these cookies that are used by third-party advertisers.
Third Party Privacy Policies
Smoke Free's Privacy Policy does not apply to other advertisers or websites. Thus, we are advising you to consult the respective Privacy Policies of these third-party ad servers for more detailed information. It may include their practices and instructions about how to opt-out of certain options.
Children's Information
Another part of our priority is adding protection for children while using the internet. We encourage parents and guardians to observe, participate in, and/or monitor and guide their online activity.
Smoke Free does not knowingly collect any Personal Identifiable Information from children under the age of 13. If you think that your child provided this kind of information on our App, we strongly encourage you to contact us immediately and we will do our best efforts to promptly remove such information from our records.
Online Privacy Policy Only
This Privacy Policy applies only to our online activities and is valid for visitors to our App with regards to the information that they shared and/or collect in Smoke Free. This policy is not applicable to any information collected offline or via channels other than this app. Our Privacy Policy was created with the help of the App Privacy Policy Generator
Consent
By using our app, you hereby consent to our Privacy Policy and agree to its Terms and Conditions.

Disclaimer for Smoke Free
We are doing our best to prepare the content of this app. However, Smoke Free cannot warranty the expressions and suggestions of the contents, as well as its accuracy. In addition, to the extent permitted by the law, Smoke Free shall not be responsible for any losses and/or damages due to the usage of the information on our app. Our Disclaimer was generated with the help of the App Disclaimer Generator
By using our app, you hereby consent to our disclaimer and agree to its terms.
Any links contained in our app may lead to external sites are provided for convenience only. Any information or statements that appeared in these sites or app are not sponsored, endorsed, or otherwise approved by Smoke Free. For these external sites, Smoke Free cannot be held liable for the availability of, or the content located on or through it. Plus, any losses or damages occurred from using these contents or the internet generally.

End-User License Agreement (EULA) of Smoke Free
This End-User License Agreement ("EULA") is a legal agreement between you and Smoke Free
This EULA agreement governs your acquisition and use of our Smoke Free software ("Software") directly from Smoke Free or indirectly through a Smoke Free authorized reseller or distributor (a "Reseller").
Please read this EULA agreement carefully before completing the installation process and using the Smoke Free software. It provides a license to use the Smoke Free software and contains warranty information and liability disclaimers.
If you register for a free trial of the Smoke Free software, this EULA agreement will also govern that trial. By clicking "accept" or installing and/or using the Smoke Free software, you are confirming your acceptance of the Software and agreeing to become bound by the terms of this EULA agreement.
If you are entering into this EULA agreement on behalf of a company or other legal entity, you represent that you have the authority to bind such entity and its affiliates to these terms and conditions. If you do not have such authority or if you do not agree with the terms and conditions of this EULA agreement, do not install or use the Software, and you must not accept this EULA agreement.
This EULA agreement shall apply only to the Software supplied by Smoke Free herewith regardless of whether other software is referred to or described herein. The terms also apply to any Smoke Free updates, supplements, Internet-based services, and support services for the Software, unless other terms accompany those items on delivery. If so, those terms apply.
License Grant
Smoke Free hereby grants you a personal, non-transferable, non-exclusive licence to use the Smoke Free software on your devices in accordance with the terms of this EULA agreement.
You are permitted to load the Smoke Free software (for example a PC, laptop, mobile or tablet) under your control. You are responsible for ensuring your device meets the minimum requirements of the Smoke Free software.
You are not permitted to:
Edit, alter, modify, adapt, translate or otherwise change the whole or any part of the Software nor permit the whole or any part of the Software to be combined with or become incorporated in any other software, nor decompile, disassemble or reverse engineer the Software or attempt to do any such things
Reproduce, copy, distribute, resell or otherwise use the Software for any commercial purpose
Allow any third party to use the Software on behalf of or for the benefit of any third party
Use the Software in any way which breaches any applicable local, national or international law
use the Software for any purpose that Smoke Free considers is a breach of this EULA agreement
Intellectual Property and Ownership
Smoke Free shall at all times retain ownership of the Software as originally downloaded by you and all subsequent downloads of the Software by you. The Software (and the copyright, and other intellectual property rights of whatever nature in the Software, including any modifications made thereto) are and shall remain the property of Smoke Free.
Smoke Free reserves the right to grant licences to use the Software to third parties.
Termination
This EULA agreement is effective from the date you first use the Software and shall continue until terminated. You may terminate it at any time upon written notice to Smoke Free.
It will also terminate immediately if you fail to comply with any term of this EULA agreement. Upon such termination, the licenses granted by this EULA agreement will immediately terminate and you agree to stop all access and use of the Software. The provisions that by their nature continue and survive will survive any termination of this EULA agreement. This EULA was created by App EULA Generator for Smoke Free
Governing Law
This EULA agreement, and any dispute arising out of or in connection with this EULA agreement, shall be governed by and construed in accordance with the laws of bd.
 
              ''',
              textAlign: TextAlign.justify,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
