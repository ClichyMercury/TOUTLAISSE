import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:threads/pages/home.dart';

import '../../widget/custom/rippleButton.dart';

class ThreadPage extends StatefulWidget {
  const ThreadPage({super.key});

  @override
  State<ThreadPage> createState() => _ThreadPageState();
}

class _ThreadPageState extends State<ThreadPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: EdgeInsets.only(bottom: 30),
                child: RippleButton(
                    splashColor: Colors.transparent,
                    child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width - 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                            child: Text(
                          "Join TOUTLAISSE",
                          style: TextStyle(
                              fontFamily: "icons.ttf",
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ))),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    })),
          ],
        ),
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: ListView(
          children: [
            Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                height: 10,
              ),
              Text(
                "How TOUTLAISSE works",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              Container(
                height: 30,
              ),
              Container(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 20,
                  ),
                  Icon(
                    CupertinoIcons.person,
                    color: Colors.white,
                    size: 30,
                  ),
                  Container(
                    width: 10,
                  ),
                  Text(
                    "Freedom of Expression",
                    style: TextStyle(
                        fontFamily: "arial",
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
              Container(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                  ),
                  Container(
                    height: 145,
                    child: Text(
                      "At 'TOUTLAISSE' we believe in freedom\nof expression. Users can share\nwhat they're passionate about,\nwhether in the form of text, photos,\nvideos, or links, without the fear\nof censorship.",
                      style: TextStyle(
                          fontFamily: "arial",
                          fontSize: 15,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          wordSpacing: 1.2),
                    ),
                  )
                ],
              ),
              Container(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 20,
                  ),
                  Icon(
                    CupertinoIcons.person,
                    color: Colors.white,
                    size: 30,
                  ),
                  Container(
                    width: 10,
                  ),
                  Text(
                    "Engaged Community",
                    style: TextStyle(
                        fontFamily: "arial",
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
              Container(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                  ),
                  Container(
                    height: 125,
                    child: Text(
                      "Our platform brings together a diverse\ncommunity of individuals with varied\ninterests. Discussions are lively and\nenriching, and you can find groups and\nforums on a multitude of topics.",
                      style: TextStyle(
                          fontFamily: "arial",
                          fontSize: 15,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          wordSpacing: 1.2),
                    ),
                  )
                ],
              ),
              Container(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 20,
                  ),
                  Icon(
                    CupertinoIcons.person,
                    color: Colors.white,
                    size: 30,
                  ),
                  Container(
                    width: 10,
                  ),
                  Text(
                    "Following and Subscriptions",
                    style: TextStyle(
                        fontFamily: "arial",
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
              Container(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                  ),
                  Container(
                    height: 145,
                    child: Text(
                      "Users can follow people and content\nthat interest them the most, creating\na personalized feed of posts. You can\nalso choose to subscribe to specific\ntopics",
                      style: TextStyle(
                          fontFamily: "arial",
                          fontSize: 15,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          wordSpacing: 1.2),
                    ),
                  )
                ],
              ),
              Container(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 20,
                  ),
                  Icon(
                    CupertinoIcons.person,
                    color: Colors.white,
                    size: 30,
                  ),
                  Container(
                    width: 10,
                  ),
                  Text(
                    "Facilitated Interaction",
                    style: TextStyle(
                        fontFamily: "arial",
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
              Container(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                  ),
                  Container(
                    height: 145,
                    child: Text(
                      "TOUTLAISSE encourages social\ninteractions. You can like, comment\non, and share posts from friends and\ncontacts while engaging in\nmeaningful discussions",
                      style: TextStyle(
                          fontFamily: "arial",
                          fontSize: 15,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          wordSpacing: 1.2),
                    ),
                  )
                ],
              ),
              Container(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 20,
                  ),
                  Icon(
                    CupertinoIcons.person,
                    color: Colors.white,
                    size: 30,
                  ),
                  Container(
                    width: 10,
                  ),
                  Text(
                    "Security and Privacy",
                    style: TextStyle(
                        fontFamily: "arial",
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
              Container(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                  ),
                  Container(
                    height: 145,
                    child: Text(
                      "We place a strong emphasis on user\nsecurity and privacy. You have control\nover who can see your posts, and we\ntake measures to protect your\npersonal data",
                      style: TextStyle(
                          fontFamily: "arial",
                          fontSize: 15,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          wordSpacing: 1.2),
                    ),
                  )
                ],
              ),
              Container(
                height: 20,
              ),
            ]),
          ],
        ));
  }
}
