import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:web_ant_project/bloc/news/news_bloc.dart';
import 'package:web_ant_project/screens/news_details/news_details.screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_ant_project/services/news_services.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsBloc, NewsState>(
      builder: (context, state) {
        return switch (state) {
          final NewsInitial _ => const ListForInitial(),
          final NewsLoading _ => const ListForLoading(),
          final NewsFailure _ => const ListForFailure(),
          final NewsSuccess state => ListForSuccess(state: state)
        };
      },
    );
  }
}

class ListForSuccess extends StatelessWidget {
  const ListForSuccess({
    super.key,
    required this.state,
  });

  final NewsSuccess state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            context.read<NewsBloc>().add(RefreshNews());
          },
        ),
        title: const Text('Все новости', style: TextStyle(fontSize: 20)),
      ),
      body: ListView.builder(
          itemCount: state.news.length,
          itemBuilder: (context, index) {
            final newsItem = state.news[index];
            return ListTile(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return NewsDetailsScreen(
                    news: newsItem,
                  );
                }));
              },
              leading: (newsItem.imageUrl != null)
                  ? Container(
                      width: 70,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          image: DecorationImage(
                              image: NetworkImage(
                                newsItem.imageUrl!,
                              ),
                              fit: BoxFit.cover)),
                    )
                  : const SizedBox.shrink(),
              title: Text(
                newsItem.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                newsItem.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            );
          }),
    );
  }
}

class ListForFailure extends StatelessWidget {
  const ListForFailure({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {},
          ),
          title: const Text('Все новости', style: TextStyle(fontSize: 20)),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
                child: Text(
              'Ошибка',
              style: TextStyle(fontSize: 20),
            )),
            Center(
              child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                  color: Colors.white,
                  elevation: 1,
                  onPressed: () {
                    context.read<NewsBloc>().add(RefreshNews());
                  },
                  child: const Text('Попробуйте ещё раз')),
            )
          ],
        ));
  }
}

class ListForLoading extends StatelessWidget {
  const ListForLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {},
          ),
          title: const Text('Все новости', style: TextStyle(fontSize: 20)),
        ),
        body: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: CircularProgressIndicator(color: Colors.blue)),
            Center(
              child: Text('Загрузка новостей...'),
            )
          ],
        ));
  }
}

class ListForInitial extends StatelessWidget {
  const ListForInitial({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {},
          ),
          title: const Text('Все новости', style: TextStyle(fontSize: 20)),
        ),
        body: const SizedBox.shrink());
  }
}
