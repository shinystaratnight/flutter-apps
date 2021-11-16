import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tao/cards/group_card.dart';
import 'package:tao/config/config.dart';
import 'package:tao/models/music.dart';
import 'package:tao/models/music_group.dart';
import 'package:tao/utils/empty.dart';
import 'package:tao/widgets/drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController? controller;
  bool? _hasData;
  final List<MusicGroup> _groups = [];

  loadData() {
    MusicGroup mg1 = MusicGroup();
    mg1.title = 'Il corpo e la mente';
    mg1.backgroundImage = 'assets/images/group_1.jpg';
    mg1.content =
        'Nove meditazioni per liberare la mente e riscoprire la presenza del proprio corpo Per ritornare ad essere presenti a se stessi Qui ed ora';
    mg1.totalMusic = 9;
    mg1.playedMusics = 1;
    mg1.backgroundColor = 0xff303021;
    mg1.musics = [];
    Music music = Music();
    music.name = 'calmare la mente';
    music.url =
        'https://drive.google.com/file/d/16A6R2pKAt9UyYmiG9LybqnmDlmEHzgmB/view?usp=sharing';
    music.length = 10;
    mg1.musics!.add(music);
    music = Music();
    music.name = 'cambiare un abitudine';
    music.url =
        'https://drive.google.com/file/d/139dxC-67nyushnS2quUDdtYVBdcJAMmz/view?usp=sharing';
    music.length = 10;
    mg1.musics!.add(music);
    music = Music();
    music.name = 'consapevolezza del corpo';
    music.url =
        'https://drive.google.com/file/d/1obVx6gZEbOry2Diri6WDU-zkd9q6pnp4/view?usp=sharing';
    music.length = 10;
    mg1.musics!.add(music);
    music = Music();
    music.name = 'Copia di calmare la mente';
    music.url =
        'https://drive.google.com/file/d/13dlLWTLiWvWoP4hV-juYxch9Koasqh7t/view?usp=sharing';
    music.length = 8;
    mg1.musics!.add(music);
    music = Music();
    music.name = 'Copia di calmare la mente';
    music.url =
        'https://drive.google.com/file/d/1AR563sj8d2BbgmP4UbxzxcpdtgyCm84K/view?usp=sharing';
    music.length = 9;
    mg1.musics!.add(music);
    music = Music();
    music.name = 'Copia di calmare la mente';
    music.url =
        'https://drive.google.com/file/d/1aYQtfcbv8vrblpp_nVt6-fMnitk32st8/view?usp=sharing';
    music.length = 12;
    mg1.musics!.add(music);
    music = Music();
    music.name = 'gentilezza';
    music.url =
        'https://drive.google.com/file/d/1Y3FMndAdIIPt0_PmYZgRWDkhBaNfUdj2/view?usp=sharing';
    music.length = 22;
    mg1.musics!.add(music);
    music = Music();
    music.name = 'immagini';
    music.url =
        'https://drive.google.com/file/d/1n5bJA5qYwjkjN9h7CENO7ietXPIliAMt/view?usp=sharing';
    music.length = 16;
    mg1.musics!.add(music);
    music = Music();
    music.name = 'interesse_e_attenzione';
    music.url =
        'https://drive.google.com/file/d/1PlIznzU5bNK9jsUpphFcXPdGiL6BBal1/view?usp=sharing';
    music.length = 22;
    mg1.musics!.add(music);
    music = Music();
    music.name = 'Liberare la mente e concentrazione';
    music.url =
        'https://drive.google.com/file/d/1VdxcSy70qTbnsM1UuDzrNKVm8VPOa8b5/view?usp=sharing';
    music.length = 22;
    mg1.musics!.add(music);
    music = Music();
    music.name = 'mangiare consapevolmente';
    music.url =
        'https://drive.google.com/file/d/13RiZ9H8ZVvXfI-lj0cU_HH6S3KiY21SL/view?usp=sharing';
    music.length = 22;
    mg1.musics!.add(music);
    music = Music();
    music.name = 'semplicità e benessere';
    music.url =
        'https://drive.google.com/file/d/1v3I7pcvQpTtB1TinUlRgHUkWxLWxEugB/view?usp=sharing';
    music.length = 22;
    mg1.musics!.add(music);

    MusicGroup mg2 = MusicGroup();
    mg2.title = 'L\'anima e le emozioni';
    mg2.backgroundImage = 'assets/images/group_2.jpg';
    mg2.content =
        'Dieci meditazioni per rischiarare l’anima ed integrare le proprie emozioni nel vissuto quotidiano, con equilibrio ed armonia';
    mg2.totalMusic = 10;
    mg2.playedMusics = 2;
    mg2.backgroundColor = 0xff7489A3;
    mg2.musics = [];
    music = Music();
    music.name = 'ascolto consapevole';
    music.url =
        'https://drive.google.com/file/d/17Gd-MmStCyL9SWsicfv5ToDqnCZKLHkj/view?usp=sharing';
    music.length = 6;
    mg2.musics!.add(music);
    music = Music();
    music.name = 'calma e raccoglimento';
    music.url =
        'https://drive.google.com/file/d/1l1IzIf-dkKxUIh2d817BSjSk1FYStYtN/view?usp=sharing';
    music.length = 8;
    mg2.musics!.add(music);
    music = Music();
    music.name = 'equilibrio mentale ed emotivo';
    music.url =
        'https://drive.google.com/file/d/1Zxk3GQFjDbfZOs-GKUiqTKBQpiK7U0Yc/view?usp=sharing';
    music.length = 8;
    mg2.musics!.add(music);
    music = Music();
    music.name = 'Il perdono';
    music.url =
        'https://drive.google.com/file/d/1PXHkailhYAhKa_RjAUeFJD40oxFMMqzy/view?usp=sharing';
    music.length = 7;
    mg2.musics!.add(music);
    music = Music();
    music.name = 'la comprensione';
    music.url =
        'https://drive.google.com/file/d/1L-hZj5fAbwXRb3ArqAMqLXQQtnaYHD0y/view?usp=sharing';
    music.length = 10;
    mg2.musics!.add(music);
    music = Music();
    music.name = 'La fiducia';
    music.url =
        'https://drive.google.com/file/d/1C1WdIedRkEAf3hZzaj2zx-691E3z5Ukg/view?usp=sharing';
    music.length = 15;
    mg2.musics!.add(music);
    music = Music();
    music.name = 'meditazione per affrontare il dolore';
    music.url =
        'https://drive.google.com/file/d/1lttVzkP8EJ1hRz1bIfQOegfgf4hiL-as/view?usp=sharing';
    music.length = 10;
    mg2.musics!.add(music);
    music = Music();
    music.name = 'pazienza e accettazione';
    music.url =
        'https://drive.google.com/file/d/1KTkmSSyzuVYSBh9E47OmKUTWJ2Q1molo/view?usp=sharing';
    music.length = 12;
    mg2.musics!.add(music);
    music = Music();
    music.name = 'superare un conflitto';
    music.url =
        'https://drive.google.com/file/d/1kfSEyxaH-mXeb58_Xtj_UDvd1fci7JMb/view?usp=sharing';
    music.length = 12;
    mg2.musics!.add(music);
    music = Music();
    music.name = 'vicinanza nel dolore';
    music.url =
        'https://drive.google.com/file/d/1C3CDGa3-Ht_r4GGOJ-QsYRN8AqL_YmYy/view?usp=sharing';
    music.length = 16;
    mg2.musics!.add(music);

    MusicGroup mg3 = MusicGroup();
    mg3.title = 'Il tempo e la presenza';
    mg3.backgroundImage = 'assets/images/group_3.jpg';
    mg3.content =
        'Quattro meditazioni per coltivare coscienza e consapevolezza, ritrovando la dimensione temporale del presente';
    mg3.totalMusic = 4;
    mg3.playedMusics = 3;
    mg3.backgroundColor = 0xff394A12;
    mg3.musics = [];
    music = Music();
    music.name = 'Camminata e un movimento consapevoli';
    music.url =
        'https://drive.google.com/file/d/1m7oLPEVKO6bmSHwUInx_sL5wFfToGLRn/view?usp=sharing';
    music.length = 17;
    mg3.musics!.add(music);
    music = Music();
    music.name = 'coltivare consapevolezza';
    music.url =
        'https://drive.google.com/file/d/1ZAZynb8dYBNCohi61aes2fJC1n4UNAOA/view?usp=sharing';
    music.length = 13;
    mg3.musics!.add(music);
    music = Music();
    music.name = 'montagna';
    music.url =
        'https://drive.google.com/file/d/1rEbzj6bHSvAHybHeDf8DUkDqn53jC9C6/view?usp=sharing';
    music.length = 12;
    mg3.musics!.add(music);
    music = Music();
    music.name = 'vivere nel presente';
    music.url =
        'https://drive.google.com/file/d/1HRC_T-QVN3rHBY2mCMjzRD3BvC9HuRcd/view?usp=sharing';
    music.length = 22;
    mg3.musics!.add(music);

    MusicGroup mg4 = MusicGroup();
    mg4.title = 'La pratica nel quotidiano';
    mg4.backgroundImage = 'assets/images/group_4.jpg';
    mg4.content =
        'Sette meditazioni efficaci per coltivare la pratica della meditazione nel quotidiano, con una mente pulita, un animo pacificato e una ritrovata dimensione temporale';
    mg4.totalMusic = 7;
    mg4.playedMusics = 5;
    mg4.backgroundColor = 0xff554A29;
    mg4.musics = [];
    music = Music();
    music.name = 'comunicazione consapevole';
    music.url =
        'https://drive.google.com/file/d/1-SGgUxzHRNrZARflHO8Tx8tXhYZCaEVj/view?usp=sharing';
    music.length = 8;
    mg4.musics!.add(music);
    music = Music();
    music.name = 'il respiro';
    music.url =
        'https://drive.google.com/file/d/1BBSgQZzdRttHIeJB_AU7XxB4ZciDqIck/view?usp=sharing';
    music.length = 6;
    mg4.musics!.add(music);
    music = Music();
    music.name = 'Il_respiro_e_la_presenza';
    music.url =
        'https://drive.google.com/file/d/1QC-EOV5fXFh8WJ9K5g83-gihE8FQUP9q/view?usp=sharing';
    music.length = 6;
    mg4.musics!.add(music);
    music = Music();
    music.name = 'sonno';
    music.url =
        'https://drive.google.com/file/d/1evXSneAODybukPb78BPdt9ylAfU2eY6N/view?usp=sharing';
    music.length = 7;
    mg4.musics!.add(music);
    music = Music();
    music.name = 'Suoni';
    music.url =
        'https://drive.google.com/file/d/18op8AflHDCWuC5zo4at8zqs74L-pUEqZ/view?usp=sharing';
    music.length = 14;
    mg4.musics!.add(music);
    music = Music();
    music.name = 'visualizzazione';
    music.url =
        'https://drive.google.com/file/d/13n9pX9pF5gvoS9zP2weSUksJME5OCeMG/view?usp=sharing';
    music.length = 14;
    mg4.musics!.add(music);
    music = Music();
    music.name = 'vita_etica';
    music.url =
        'https://drive.google.com/file/d/1tshjIOH5U4Dl9fPg6iGz-iIbZeVl_g4M/view?usp=sharing';
    music.length = 20;
    mg4.musics!.add(music);

    _groups.add(mg1);
    _groups.add(mg2);
    _groups.add(mg3);
    _groups.add(mg4);
  }

  @override
  void initState() {
    loadData();
    _hasData = true;

    super.initState();
  }

  onRefresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerMenu(),
      key: scaffoldKey,
      body: RefreshIndicator(
        onRefresh: () async => onRefresh(),
        child: CustomScrollView(
          controller: controller,
          slivers: <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              pinned: true,
              centerTitle: false,
              titleSpacing: 0,
              leading: IconButton(
                icon: Icon(
                  Feather.menu,
                  color: Colors.white,
                  size: 35,
                ),
                alignment: Alignment.topLeft,
                onPressed: () {
                  scaffoldKey.currentState!.openDrawer();
                },
              ),
              backgroundColor: Config().bgColor,
              toolbarHeight: 130,
              flexibleSpace: FlexibleSpaceBar(
                background: SvgPicture.asset(
                  'assets/images/default.svg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            _hasData == false
                ? SliverFillRemaining(
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.30,
                        ),
                        EmptyPage(
                            icon: Feather.clipboard,
                            message: 'no articles found'.tr(),
                            message1: ''),
                      ],
                    ),
                  )
                : SliverPadding(
                    padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                    sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                      if (index < _groups.length) {
                        return GroupCard(
                          d: _groups[index],
                          heroTag: 'categorybased$index',
                        );
                      }
                    })),
                  )
          ],
        ),
      ),
    );
  }
}
