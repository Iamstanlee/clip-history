import 'package:cliphistory/data/clip.dart';
import 'package:cliphistory/helpers/functions.dart';
import 'package:cliphistory/local_storage.dart';
import 'package:cliphistory/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Clip> clips;
  Storage storage = new Storage('clipboard-history.json');
  @override
  void initState() {
    super.initState();
    // initialize local storage and fetch clip history
    storage.init().then((isReady) {
      if (isReady) {
        List<dynamic> items = storage.getItemFromStore('clips');
        setState(() {
          if (items != null) {
            clips = items.map((item) {
              return Clip.fromMap(item);
            }).toList();
          } else {
            clips = [];
          }
        });
      }
    });
  }

  // add item to the user clip history
  void addItem() async {
    ClipboardData clipboard = await Clipboard.getData('text/plain');
    if (clipboard.text.length > 128) {
      Toast.show(
          "The text on clipboard is too long, the max length is '128'", context,
          backgroundColor: Colors.red);
    } else {
      DateTime timestamp = DateTime.now();
      Map<String, dynamic> newClip = {};
      newClip['clip'] = clipboard.text;
      newClip['time'] = formatTime(timestamp);
      newClip['date'] = formatDate(timestamp);
      List<Map<String, dynamic>> clipsInMap = getClipsInMap();
      clipsInMap.add(newClip);
      storage.addItemToStore('clips', clipsInMap);
      setState(() {
        clips.add(Clip.fromMap(newClip));
      });
      Toast.show('New item added to clip history', context);
    }
  }

  // map List<Clip> to List<Map>
  List<Map<String, dynamic>> getClipsInMap() {
    return clips.map((clip) {
      return Clip.toMap(clip);
    }).toList();
  }

  // delete the item at [index] and update storage accordindly
  void deleteItem(int index) {
    List<Map<String, dynamic>> clipsInMap = getClipsInMap();
    clipsInMap.removeAt(index);
    storage.addItemToStore('clips', clipsInMap);
    setState(() {
      clips.removeAt(index);
    });
    Toast.show('Item deleted from clip history', context);
  }

  // copy the long pressed item to the device clipboard
  void copyItemToClipboard(Clip clip) async {
    await Clipboard.setData(ClipboardData(text: clip.clip));
    Toast.show('Copied to clipboard', context);
  }

  void shareMyApp() {
    Share.share('Heyo, Check out this awesome app !');
  }

  @override
  Widget build(BuildContext context) {
    // sort the clips by their timestamps so newer ones appear at the top
    return Scaffold(
      appBar: AppBar(
        title: Text("Clip History", style: TextStyle()),
        actions: <Widget>[
          IconButton(
              icon: ImageIcon(
                AssetImage(getPng('icon-share')),
                size: 21,
              ),
              onPressed: shareMyApp),
          IconButton(
              icon: ImageIcon(
                AssetImage(getPng('icon-help')),
              ),
              onPressed: () {})
        ],
      ),
      body: clips == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Loading...',
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            )
          : clips.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "You\'ve got nothing on your clip history, tap ' + ' to add from clipboard",
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                )
              : ListView(
                  children: clips
                      .map<Widget>((c) {
                        int i = clips.indexOf(c);
                        return clipItem(context,
                            clip: c.clip,
                            time: c.time,
                            date: c.date, deleteItem: () {
                          deleteItem(i);
                        }, copyToClipboard: () {
                          copyItemToClipboard(c);
                        });
                      })
                      .toList()
                      .reversed
                      .toList(),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: addItem,
        child: Icon(Icons.add),
      ),
    );
  }
}

Widget clipItem(BuildContext context,
    {String clip,
    String time,
    String date,
    Function deleteItem,
    Function copyToClipboard}) {
  return InkWell(
    onLongPress: () {
      copyToClipboard();
    },
    child: Container(
      height: getHeight(context, height: 7),
      margin: EdgeInsets.only(left: 15),
      child: Dismissible(
        onDismissed: (direction) {
          deleteItem();
        },
        key: Key('$time'),
        background: Container(color: Colors.red),
        child: Row(
          children: <Widget>[
            Container(color: Colors.black54, height: 4, width: 4),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('$clip',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style:
                            TextStyle(color: Colors.black87, fontSize: 17.0)),
                    Text('$date . $time',
                        style: TextStyle(color: Colors.grey, fontSize: 12.0)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
