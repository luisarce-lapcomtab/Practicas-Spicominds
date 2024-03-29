import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: const Text(
          'Mensajes',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: const ListMessages(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.edit_note),
      ),
    );
  }
}

class ListMessages extends StatelessWidget {
  const ListMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> items = List.generate(
        9,
        (index) => InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NewMessages(index: index)),
                );
              },
              child: Container(
                margin: const EdgeInsets.all(1.0),
                height: 70,
                color: Colors.primaries[index % Colors.primaries.length],
                child: ListTile(
                  title: Text(
                    'Especialista - $index',
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: const Text(
                    'Hello, how are you?',
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: const FadeInImage(
                      placeholder: AssetImage('assets/no-image.jpg'),
                      image: NetworkImage(
                          "https://source.unsplash.com/100x130/?portrait"),
                      fit: BoxFit.cover,
                      height: 50,
                      width: 50,
                    ),
                  ),
                ),
              ),
            ));

    return CustomScrollView(
        // physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate((context, i) {
              return items[i];
            }, childCount: items.length),
          ),
        ]);
  }
}

class NewMessages extends StatelessWidget {
  final int index;
  const NewMessages({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white, size: 28),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: Text(' Especialista - $index',
            style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
                onPressed: () async {
                  final Uri url = Uri(scheme: 'tel', path: '0987654321');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    // ignore: avoid_print
                    print('error url');
                  }
                },
                icon: const Icon(Icons.local_phone)),
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[50],
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
              reverse: true,
              itemCount: 2,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Text(
                        'Hello, how are you? ',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Text(
                      ' Hi! 🖐',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            )),
            const MessageBox(),
          ],
        ),
      ),
    );
  }
}

class MessageBox extends StatefulWidget {
  const MessageBox({super.key});

  @override
  State<MessageBox> createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageBox> {
  late TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _inputOnChanged(String query) async {
    if (query.isNotEmpty) {
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      child: Row(
        children: [
          Expanded(
              child: Material(
            elevation: 2,
            shape: const StadiumBorder(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _controller,
                onSubmitted: _inputOnChanged,
                decoration: const InputDecoration(
                  hintText: 'Escribe un mensaje',
                  border: InputBorder.none,
                ),
              ),
            ),
          )),
          const SizedBox(width: 10),
          Material(
            elevation: 2,
            shape: const CircleBorder(),
            color: Colors.deepPurple,
            child: IconButton(
                onPressed: () => _inputOnChanged(_controller.text),
                icon: const Icon(
                  Icons.send,
                  color: Colors.white,
                )),
          )
        ],
      ),
    );
  }
}
