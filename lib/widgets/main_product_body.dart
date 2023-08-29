import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_ui/widgets/header_section.dart';
import 'package:e_commerce_ui/widgets/product_list_section.dart';
import 'package:e_commerce_ui/widgets/story_view_section.dart';
import 'package:flutter/material.dart';

class MainProductBody extends StatefulWidget {
  const MainProductBody({super.key});

  @override
  State<MainProductBody> createState() => _MainProductBodyState();
}

class _MainProductBodyState extends State<MainProductBody> {
  PageController pageController = PageController(viewportFraction: 0.83);
  double _currentPageValue = 0.0;
  double _scaleFactor = 0.8;
  double _height = 220.0;

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      setState(() {
        _currentPageValue = pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 65,
          ),
          const HeaderSection(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const StoryViewSection(),
                  const SizedBox(
                    height: 15,
                  ),
                  ProductListSection(
                    title: 'Categories',
                    categoryWidget: category(),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const ProductListSection(title: 'Hot Item'),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 200,
                    child: PageView.builder(
                        controller: pageController,
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return sliderList(index);
                        }),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const ProductListSection(title: 'New Arrivals'),
                  const SizedBox(height: 15,),
                ],
              ),
            ),
          ),

        ],
      ),

    );
  }

  Widget category() {
    final List<String> categoryName = [
      'Cooking',
      'Fish & Meat',
      'Masala',
      'Meat',
      'Groceries'
    ];
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categoryName.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Column(
              children: [
                CachedNetworkImage(
                  height: 70,
                  width: 40,
                  fit: BoxFit.contain,
                  imageUrl:
                      'https://shinjukuhalalfood.com/wp-content/uploads/2023/07/Daawat-Everyday-FB-Reel.png',
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                    child: CircularProgressIndicator(
                        value: downloadProgress.progress),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(categoryName[index]),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget sliderList(int index) {
    Matrix4 matrix = Matrix4.identity();
    if (index == _currentPageValue.floor()) {
      var currentScale = 1 - (_currentPageValue - index) * (1 - _scaleFactor);
      var currentTransform = _height * (1 - currentScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currentScale, 1)
        ..setTranslationRaw(0, currentTransform, 0);
    } else if (index == _currentPageValue.floor() + 1) {
      var currentScale =
          _scaleFactor + (_currentPageValue - index + 1) * (1 - _scaleFactor);
      var currentTransform = _height * (1 - currentScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currentScale, 1);
      matrix = Matrix4.diagonal3Values(1, currentScale, 1)
        ..setTranslationRaw(0, currentTransform, 0);
    } else if (index == _currentPageValue.floor() - 1) {
      var currentScale = 1 - (_currentPageValue - index) * (1 - _scaleFactor);
      var currentTransform = _height * (1 - currentScale) / 2;
      matrix = Matrix4.diagonal3Values(1, currentScale, 1);
      matrix = Matrix4.diagonal3Values(1, currentScale, 1)
        ..setTranslationRaw(0, currentTransform, 0);
    } else {
      var currentScale = _scaleFactor;
      matrix = Matrix4.diagonal3Values(1, currentScale, 1)
        ..setTranslationRaw(0, _height * (1 - _scaleFactor) / 2, 1);
    }
    return Transform(
      transform: matrix,
      child: Container(
        height: 150,
        margin: const EdgeInsets.only(left: 5, right: 5),
        decoration: BoxDecoration(
          color: index.isEven ? Colors.redAccent : Colors.amberAccent,
          image: const DecorationImage(
              image: NetworkImage(
                  'https://shinjukuhalalfood.com/wp-content/uploads/2022/10/deer_meat_shinjukuhalalfood.png'),
              fit: BoxFit.cover),
        ),
      ),
    );
  }
}
