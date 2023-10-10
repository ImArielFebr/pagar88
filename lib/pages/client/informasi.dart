import 'package:flutter/material.dart';
import 'package:p88/pages/client/tutorialbatal.dart';
import 'package:p88/pages/client/tutorialbuat.dart';
import 'package:p88/pages/client/tutorialcek.dart';
import 'package:page_route_animator/page_route_animator.dart';

class Informasi extends StatelessWidget {
  const Informasi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        toolbarHeight: 75,
        shadowColor: Colors.black87,
        title: Text("#88", style: Theme
            .of(context)
            .textTheme
            .headlineMedium?.copyWith(color: Colors.black),),
        centerTitle: true,
        elevation: 5,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ElevatedButton(
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(Colors.white),
                      padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
                      fixedSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width / 1.1, MediaQuery.of(context).size.height / 12)),
                      backgroundColor: MaterialStateProperty.all(Colors.lightBlue),
                      animationDuration: const Duration(milliseconds: 500),
                      elevation: MaterialStateProperty.all(10),
                      shadowColor: MaterialStateProperty.all(Colors.black87),
                      alignment: Alignment.centerLeft,
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          )
                      )
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                        PageRouteAnimator(
                          child: const TutorialBuat(),
                          routeAnimation: RouteAnimation.fadeAndScale,
                          curve: Curves.easeOut,
                        )
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(width: 10,),
                      Text('Cara Buat Pengaduan', textAlign: TextAlign.center, style: Theme
                          .of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ElevatedButton(
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(Colors.white),
                      padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
                      fixedSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width / 1.1, MediaQuery.of(context).size.height / 12)),
                      backgroundColor: MaterialStateProperty.all(Colors.lightBlue),
                      animationDuration: const Duration(milliseconds: 500),
                      elevation: MaterialStateProperty.all(10),
                      shadowColor: MaterialStateProperty.all(Colors.black87),
                      alignment: Alignment.centerLeft,
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          )
                      )
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                        PageRouteAnimator(
                          child: const TutorialCek(),
                          routeAnimation: RouteAnimation.fadeAndScale,
                          curve: Curves.easeOut,
                        )
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(width: 10,),
                      Text('Cara Cek Pengaduan', textAlign: TextAlign.center, style: Theme
                          .of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ElevatedButton(
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(Colors.white),
                      padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
                      fixedSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width / 1.1, MediaQuery.of(context).size.height / 12)),
                      backgroundColor: MaterialStateProperty.all(Colors.lightBlue),
                      animationDuration: const Duration(milliseconds: 500),
                      elevation: MaterialStateProperty.all(10),
                      shadowColor: MaterialStateProperty.all(Colors.black87),
                      alignment: Alignment.centerLeft,
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          )
                      )
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                        PageRouteAnimator(
                          child: const TutorialBatal(),
                          routeAnimation: RouteAnimation.fadeAndScale,
                          curve: Curves.easeOut,
                        )
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(width: 10,),
                      Text('Cara Cabut Pengaduan', textAlign: TextAlign.center, style: Theme
                          .of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 3,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Align(
                  alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(Colors.lightBlueAccent),
                          padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
                          fixedSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width / 1.1, MediaQuery.of(context).size.width / 6)),
                          backgroundColor: MaterialStateProperty.all(Colors.white),
                          animationDuration: const Duration(milliseconds: 500),
                          elevation: MaterialStateProperty.all(10),
                          shadowColor: MaterialStateProperty.all(Colors.black87),
                          alignment: Alignment.centerLeft,
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                side: const BorderSide(color: Colors.black, width: 2),
                              )
                          )
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(width: 10,),
                          Text('Tutup', textAlign: TextAlign.center, style: Theme
                              .of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(color: Colors.black, fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                  ),
              )
            ],
          ),
        )
      ),
    );
  }
}
