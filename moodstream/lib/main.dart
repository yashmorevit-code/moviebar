import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';
import 'package:youtube_player_iframe/youtube_player_iframe.dart'; 

void main() {
  runApp(const MoodStreamApp());
}

// ==========================================
// 0. GLOBAL REACTIVE STATE & DATABASE
// ==========================================
final ValueNotifier<Set<String>> globalWatchlist = ValueNotifier<Set<String>>({});
final ValueNotifier<List<Map<String, dynamic>>> globalReviews = ValueNotifier<List<Map<String, dynamic>>>([
  {"movie": "The Godfather", "rating": 5, "text": "An absolute masterpiece. Cinema at its peak."},
  {"movie": "Interstellar", "rating": 4, "text": "Visually stunning, though the ending was a bit mind-bending."}
]);

final Map<String, Map<String, dynamic>> globalMovieDatabase = {
  "Dhurandar 2": {
    "year": "2026", "duration": "3h 49m", "genre": "Action", "rating": "⭐ 8.5/10",
    "director": "Aditya Dhar", "origin": "India", "awards": "🏆 Highly Anticipated",
    "synopsis": "An undercover Indian intelligence agent infiltrates Karachi's criminal syndicates to dismantle terror networks and avenge past attacks.",
    "imageUrl": "https://imgs.etvbharat.com/etvbharat/prod-images/27-03-2026/1200-675-26343338-994-26343338-1774625497511.jpg",
    "trailerId": "NHk7scrb_9I", 
    "cast": [
      {"name": "Ranveer Singh", "image": "https://ui-avatars.com/api/?name=Ranveer+Singh&background=0D1117&color=B026FF&bold=true"},
      {"name": "Arjun Rampal", "image": "https://ui-avatars.com/api/?name=Arjun+Rampal&background=0D1117&color=B026FF&bold=true"},
      {"name": "Sanjay Dutt", "image": "https://ui-avatars.com/api/?name=Sanjay+Dutt&background=0D1117&color=B026FF&bold=true"},
    ]
  },
  "Project Hail Mary": {
    "year": "2026", "duration": "2h 36m", "genre": "Sci-Fi", "rating": "⭐ 8.8/10",
    "director": "Phil Lord, Chris Miller", "origin": "United States", "awards": "🏆 Anticipated Sci-Fi",
    "synopsis": "A lone astronaut wakes up on a spaceship with amnesia and must save Earth from an extinction-level disaster with the help of an unlikely alien ally.",
    "imageUrl": "https://i.ytimg.com/vi/m08TxIsFTRI/maxresdefault.jpg",
    "trailerId": "m08TxIsFTRI", 
    "cast": [
      {"name": "Ryan Gosling", "image": "https://ui-avatars.com/api/?name=Ryan+Gosling&background=0D1117&color=B026FF&bold=true"},
      {"name": "Sandra Hüller", "image": "https://ui-avatars.com/api/?name=Sandra+Huller&background=0D1117&color=B026FF&bold=true"},
      {"name": "James Ortiz", "image": "https://ui-avatars.com/api/?name=James+Ortiz&background=0D1117&color=B026FF&bold=true"},
    ]
  },
  "Ramayan": {
    "year": "2026", "duration": "3h 10m", "genre": "Epic / Myth", "rating": "⭐ N/A",
    "director": "Nitesh Tiwari", "origin": "India", "awards": "🏆 Upcoming Epic",
    "synopsis": "The cinematic retelling of the ancient and legendary Indian saga, bringing the timeless tale of Lord Ram to the big screen with unprecedented scale.",
    "imageUrl": "https://media.assettype.com/prajavani%2F2026-04-02%2F6hm8jksn%2Framayana-movie-teaser?w=undefined&auto=format%2Ccompress&fit=max&q=70",
    "trailerId": "1pnKd6YHmV4", 
    "cast": [
      {"name": "Ranbir Kapoor", "image": "https://ui-avatars.com/api/?name=Ranbir+Kapoor&background=0D1117&color=B026FF&bold=true"},
      {"name": "Sai Pallavi", "image": "https://ui-avatars.com/api/?name=Sai+Pallavi&background=0D1117&color=B026FF&bold=true"},
      {"name": "Yash", "image": "https://ui-avatars.com/api/?name=Yash&background=0D1117&color=B026FF&bold=true"},
    ]
  },
  "Spider-Man : Brand New Day": {
    "year": "2026", "duration": "2h 15m", "genre": "Action", "rating": "⭐ N/A",
    "director": "Destin Daniel Cretton", "origin": "United States", "awards": "🏆 Upcoming Marvel",
    "synopsis": "Our friendly neighborhood hero swings back into action to save the city from a new threat, navigating a lonely life after the world forgets Peter Parker.",
    "imageUrl": "https://i.ytimg.com/vi/BwntXFBNfOA/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLD5JB2wuuBgac23j3ddQLpZZhuEJQ",
    "trailerId": "8TZMtslA3UY", 
    "cast": [
      {"name": "Tom Holland", "image": "https://ui-avatars.com/api/?name=Tom+Holland&background=0D1117&color=B026FF&bold=true"},
      {"name": "Zendaya", "image": "https://ui-avatars.com/api/?name=Zendaya&background=0D1117&color=B026FF&bold=true"},
      {"name": "Jacob Batalon", "image": "https://ui-avatars.com/api/?name=Jacob+Batalon&background=0D1117&color=B026FF&bold=true"},
    ]
  },

  "Fall Guy": {
    "year": "2024", "duration": "2h 6m", "genre": "Action / Comedy", "rating": "⭐ 7.0/10",
    "director": "David Leitch", "origin": "United States", "awards": "🏆 1 Nom",
    "synopsis": "A down-and-out stuntman must find the missing star of his ex-girlfriend's blockbuster film while dealing with a conspiracy and trying to win her back.",
    "imageUrl": "https://m.media-amazon.com/images/S/pv-target-images/6c6a5d7b21db3595bded594c66baa9ef94c70f4cda655959640c382d69c6bbbf.jpg",
    "trailerId": "j7jPnwVGdZ8",
    "cast": [
      {"name": "Ryan Gosling", "image": "https://ui-avatars.com/api/?name=Ryan+Gosling&background=0D1117&color=B026FF&bold=true"},
      {"name": "Emily Blunt", "image": "https://ui-avatars.com/api/?name=Emily+Blunt&background=0D1117&color=B026FF&bold=true"},
      {"name": "Aaron Taylor", "image": "https://ui-avatars.com/api/?name=Aaron+Taylor&background=0D1117&color=B026FF&bold=true"},
    ]
  },
  "Mission Impossible": {
    "year": "2023", "duration": "2h 43m", "genre": "Action", "rating": "⭐ 7.7/10",
    "director": "Chris McQuarrie", "origin": "United States", "awards": "🏆 2 Noms",
    "synopsis": "Ethan Hunt and his IMF team embark on their most dangerous mission yet: to track down a terrifying new weapon that threatens all of humanity.",
    "imageUrl": "https://ntvb.tmsimg.com/assets/p18045_v_h10_ad.jpg?w=960&h=540",
    "trailerId": "L8Pbjh4EZRk",
    "cast": [
      {"name": "Tom Cruise", "image": "https://ui-avatars.com/api/?name=Tom+Cruise&background=0D1117&color=B026FF&bold=true"},
      {"name": "Hayley Atwell", "image": "https://ui-avatars.com/api/?name=Hayley+Atwell&background=0D1117&color=B026FF&bold=true"},
      {"name": "Ving Rhames", "image": "https://ui-avatars.com/api/?name=Ving+Rhames&background=0D1117&color=B026FF&bold=true"},
    ]
  },
  "Lay Bhari": {
    "year": "2014", "duration": "2h 38m", "genre": "Action / Drama", "rating": "⭐ 7.5/10",
    "director": "Nishikant Kamat", "origin": "India", "awards": "🏆 Blockbuster",
    "synopsis": "A grieving father seeks revenge after his son is killed over a property dispute. Enter Prince, a man who looks exactly like the murdered son.",
    "imageUrl": "https://images.plex.tv/photo?size=large-1280&url=https%3A%2F%2Fmetadata-static.plex.tv%2F6%2Fgracenote%2F6f0ab58141420a894350f24b7b905d88.jpg",
    "trailerId": "SuYP1viwc3M",
    "cast": [
      {"name": "Riteish Deshmukh", "image": "https://ui-avatars.com/api/?name=Riteish+Deshmukh&background=0D1117&color=B026FF&bold=true"},
      {"name": "Sharad Kelkar", "image": "https://ui-avatars.com/api/?name=Sharad+Kelkar&background=0D1117&color=B026FF&bold=true"},
      {"name": "Radhika Apte", "image": "https://ui-avatars.com/api/?name=Radhika+Apte&background=0D1117&color=B026FF&bold=true"},
    ]
  },

  "Interstellar": {
    "year": "2014", "duration": "2h 49m", "genre": "Sci-Fi", "rating": "⭐ 8.7/10",
    "director": "Christopher Nolan", "origin": "United States", "awards": "🏆 1 Oscar",
    "synopsis": "A team of explorers travel through a wormhole in space in an attempt to ensure humanity's survival as Earth's resources are being depleted.",
    "imageUrl": "https://media.idownloadblog.com/wp-content/uploads/2014/12/Interstellar-Movie-Official-Trailer-HD-2014.jpg",
    "trailerId": "2LqzF5WauAw",
    "cast": [
      {"name": "Matthew McConaughey", "image": "https://ui-avatars.com/api/?name=Matthew+McConaughey&background=0D1117&color=B026FF&bold=true"},
      {"name": "Anne Hathaway", "image": "https://ui-avatars.com/api/?name=Anne+Hathaway&background=0D1117&color=B026FF&bold=true"},
      {"name": "Jessica Chastain", "image": "https://ui-avatars.com/api/?name=Jessica+Chastain&background=0D1117&color=B026FF&bold=true"},
    ]
  },
  "Matrix": {
    "year": "1999", "duration": "2h 16m", "genre": "Sci-Fi", "rating": "⭐ 8.7/10",
    "director": "The Wachowskis", "origin": "United States", "awards": "🏆 4 Oscars",
    "synopsis": "A computer hacker learns from mysterious rebels about the true nature of his reality and his role in the war against its controllers.",
    "imageUrl": "https://venkatarangan.com/wp-content/uploads/2018/01/the-matrix-1999.jpg",
    "trailerId": "vKQi3bBA1y8",
    "cast": [
      {"name": "Keanu Reeves", "image": "https://ui-avatars.com/api/?name=Keanu+Reeves&background=0D1117&color=B026FF&bold=true"},
      {"name": "Laurence Fishburne", "image": "https://ui-avatars.com/api/?name=Laurence+Fishburne&background=0D1117&color=B026FF&bold=true"},
      {"name": "Carrie-Anne Moss", "image": "https://ui-avatars.com/api/?name=Carrie-Anne+Moss&background=0D1117&color=B026FF&bold=true"},
    ]
  },
  "Ra-One": {
    "year": "2011", "duration": "2h 36m", "genre": "Sci-Fi", "rating": "⭐ 4.8/10",
    "director": "Anubhav Sinha", "origin": "India", "awards": "🏆 1 National Award",
    "synopsis": "A video game developer creates a villain more powerful than the hero. Things go horribly wrong when the villain escapes the game into the real world.",
    "imageUrl": "https://images.ottplay.com/images/raone-14.jpg",
    "trailerId": "prRdhKyGRm8",
    "cast": [
      {"name": "Shah Rukh Khan", "image": "https://ui-avatars.com/api/?name=Shah+Rukh+Khan&background=0D1117&color=B026FF&bold=true"},
      {"name": "Kareena Kapoor", "image": "https://ui-avatars.com/api/?name=Kareena+Kapoor&background=0D1117&color=B026FF&bold=true"},
      {"name": "Arjun Rampal", "image": "https://ui-avatars.com/api/?name=Arjun+Rampal&background=0D1117&color=B026FF&bold=true"},
    ]
  },

  "The Godfather": {
    "year": "1972", "duration": "2h 55m", "genre": "Drama", "rating": "⭐ 9.2/10",
    "director": "Francis F. Coppola", "origin": "United States", "awards": "🏆 3 Oscars",
    "synopsis": "The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son in this cinematic masterpiece.",
    "imageUrl": "https://live.staticflickr.com/3464/3864721378_ab336d4a0a.jpg",
    "trailerId": "UaVTIH8mujA",
    "cast": [
      {"name": "Marlon Brando", "image": "https://ui-avatars.com/api/?name=Marlon+Brando&background=0D1117&color=B026FF&bold=true"},
      {"name": "Al Pacino", "image": "https://ui-avatars.com/api/?name=Al+Pacino&background=0D1117&color=B026FF&bold=true"},
      {"name": "James Caan", "image": "https://ui-avatars.com/api/?name=James+Caan&background=0D1117&color=B026FF&bold=true"},
    ]
  },
  "Fight Club": {
    "year": "1999", "duration": "2h 19m", "genre": "Drama / Thriller", "rating": "⭐ 8.8/10",
    "director": "David Fincher", "origin": "United States", "awards": "🏆 Cult Classic",
    "synopsis": "An insomniac office worker and a devil-may-care soap maker form an underground fight club that evolves into much more.",
    "imageUrl": "https://lumiere-a.akamaihd.net/v1/images/fightclub_mainmenu_ka_3840x2160_98330c30.jpeg?region=0,0,1600,686",
    "trailerId": "dfeUzm6KF4g",
    "cast": [
      {"name": "Brad Pitt", "image": "https://ui-avatars.com/api/?name=Brad+Pitt&background=0D1117&color=B026FF&bold=true"},
      {"name": "Edward Norton", "image": "https://ui-avatars.com/api/?name=Edward+Norton&background=0D1117&color=B026FF&bold=true"},
      {"name": "Helena B. Carter", "image": "https://ui-avatars.com/api/?name=Helena+Bonham+Carter&background=0D1117&color=B026FF&bold=true"},
    ]
  },
  "Dead Poets Society": {
    "year": "1989", "duration": "2h 8m", "genre": "Drama", "rating": "⭐ 8.1/10",
    "director": "Peter Weir", "origin": "United States", "awards": "🏆 1 Oscar",
    "synopsis": "Maverick teacher John Keating uses poetry to embolden his boarding school students to new heights of self-expression.",
    "imageUrl": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS36MOp95O3_P4fG3IxH_8ly5y3-y986sz8VQ&s",
    "trailerId": "ye4KFyWu2do",
    "cast": [
      {"name": "Robin Williams", "image": "https://ui-avatars.com/api/?name=Robin+Williams&background=0D1117&color=B026FF&bold=true"},
      {"name": "Ethan Hawke", "image": "https://ui-avatars.com/api/?name=Ethan+Hawke&background=0D1117&color=B026FF&bold=true"},
      {"name": "Robert S. Leonard", "image": "https://ui-avatars.com/api/?name=Robert+Sean+Leonard&background=0D1117&color=B026FF&bold=true"},
    ]
  },
  "Parasite": {
    "year": "2019", "duration": "2h 12m", "genre": "Thriller", "rating": "⭐ 8.5/10",
    "director": "Bong Joon Ho", "origin": "South Korea", "awards": "🏆 4 Oscars",
    "synopsis": "Greed and class discrimination threaten the newly formed symbiotic relationship between the wealthy Park family and the destitute Kim clan.",
    "imageUrl": "https://images.unsplash.com/photo-1509347528160-9a9e33742cdb?q=80&w=500&auto=format&fit=crop",
    "trailerId": "5xH0HfJHsaY",
    "cast": [
      {"name": "Song Kang-ho", "image": "https://ui-avatars.com/api/?name=Song+Kang-ho&background=0D1117&color=B026FF&bold=true"},
      {"name": "Lee Sun-kyun", "image": "https://ui-avatars.com/api/?name=Lee+Sun-kyun&background=0D1117&color=B026FF&bold=true"},
      {"name": "Choi Woo-shik", "image": "https://ui-avatars.com/api/?name=Choi+Woo-shik&background=0D1117&color=B026FF&bold=true"},
    ]
  },
  "Oppenheimer": {
    "year": "2023", "duration": "3h 0m", "genre": "Drama", "rating": "⭐ 8.3/10",
    "director": "Christopher Nolan", "origin": "United States", "awards": "🏆 7 Oscars",
    "synopsis": "The story of American scientist J. Robert Oppenheimer and his role in the development of the atomic bomb.",
    "imageUrl": "https://i.ytimg.com/vi/M1Jm7jHrQQU/sddefault.jpg",
    "trailerId": "bK6ldnjE3Y0",
    "cast": [
      {"name": "Cillian Murphy", "image": "https://ui-avatars.com/api/?name=Cillian+Murphy&background=0D1117&color=B026FF&bold=true"},
      {"name": "Emily Blunt", "image": "https://ui-avatars.com/api/?name=Emily+Blunt&background=0D1117&color=B026FF&bold=true"},
      {"name": "Robert Downey Jr", "image": "https://ui-avatars.com/api/?name=Robert+Downey+Jr&background=0D1117&color=B026FF&bold=true"},
    ]
  },

  "default": {
    "year": "2024", "duration": "2h 15m", "genre": "Cinematic", "rating": "⭐ 4.5/5",
    "director": "Acclaimed Director", "origin": "Global", "awards": "🏆 Festival Selection",
    "synopsis": "A stunning cinematic experience that perfectly captures the genre you selected. Grab your popcorn and enjoy the incredible journey.",
    "imageUrl": "https://images.unsplash.com/photo-1485846234645-a62644f84728?q=80&w=500&auto=format&fit=crop",
    "trailerId": "zSWdZVtXT7E", 
    "cast": [
      {"name": "Lead Actor", "image": "https://ui-avatars.com/api/?name=Lead+Actor&background=0D1117&color=B026FF&bold=true"},
      {"name": "Supporting", "image": "https://ui-avatars.com/api/?name=Supporting+Role&background=0D1117&color=B026FF&bold=true"},
    ]
  }
};

class MoodStreamApp extends StatelessWidget {
  const MoodStreamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MovieBar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF050505), 
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFB026FF), // Neon Violet 
          surface: Color(0xFF0D1117), // Deep space grey
        ),
        fontFamily: 'Nunito',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Color(0xFFB0B0C0)),
        ),
      ),
      home: const MainNavigator(),
    );
  }
}

// ==========================================
// BACKGROUND GLOW WIDGET
// ==========================================
// This adds the soft glowing orbs behind the UI
class NeonBackground extends StatelessWidget {
  final Widget child;
  const NeonBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Top Violet Glow
        Positioned(
          top: -100, left: -50, right: -50,
          child: Container(
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFB026FF).withOpacity(0.15),
            ),
          ),
        ),
        // Bottom Deep Indigo Glow
        Positioned(
          bottom: -150, right: -100,
          child: Container(
            height: 400, width: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF30009C).withOpacity(0.15),
            ),
          ),
        ),
        // Massive Blur to smooth the glowing orbs
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
          child: Container(color: Colors.transparent),
        ),
        // The actual UI content on top
        child,
      ],
    );
  }
}

// ==========================================
// 1. MAIN NAVIGATOR
// ==========================================
class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const DiscoverScreen(),
    const WatchlistScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, 
      body: NeonBackground(child: _screens[_selectedIndex]), // Wrapped in Neon Background
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 25),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: const Color(0xFF0D1117).withOpacity(0.6), // Slightly more transparent
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(Icons.space_dashboard_outlined, Icons.space_dashboard_rounded, "Home", 0),
                  _buildNavItem(Icons.explore_outlined, Icons.explore_rounded, "Discover", 1),
                  _buildNavItem(Icons.turned_in_not, Icons.turned_in, "Watchlist", 2),
                  _buildNavItem(Icons.account_circle_outlined, Icons.account_circle, "Profile", 3),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData unselectedIcon, IconData selectedIcon, String label, int index) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutQuint,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFB026FF).withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(isSelected ? selectedIcon : unselectedIcon, color: isSelected ? const Color(0xFFB026FF) : Colors.white70, size: 26),
            ),
            if (isSelected) ...[
              const SizedBox(height: 4),
              Container(height: 4, width: 4, decoration: const BoxDecoration(color: Color(0xFFB026FF), shape: BoxShape.circle))
            ]
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 2. HOME SCREEN 
// ==========================================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  Timer? _carouselTimer;
  int _currentPage = 0;

  final List<Map<String, dynamic>> trendingMovies = [
    {"title": "Dhurandar 2", "desc": globalMovieDatabase["Dhurandar 2"]!["synopsis"], "imageUrl": globalMovieDatabase["Dhurandar 2"]!["imageUrl"]},
    {"title": "Project Hail Mary", "desc": globalMovieDatabase["Project Hail Mary"]!["synopsis"], "imageUrl": globalMovieDatabase["Project Hail Mary"]!["imageUrl"]},
    {"title": "Ramayan", "desc": globalMovieDatabase["Ramayan"]!["synopsis"], "imageUrl": globalMovieDatabase["Ramayan"]!["imageUrl"]},
    {"title": "Spider-Man : Brand New Day", "desc": globalMovieDatabase["Spider-Man : Brand New Day"]!["synopsis"], "imageUrl": globalMovieDatabase["Spider-Man : Brand New Day"]!["imageUrl"]},
  ];

  final List<Map<String, String>> actionMovies = [
    {"title": "Fall Guy", "imageUrl": globalMovieDatabase["Fall Guy"]!["imageUrl"]},
    {"title": "Mission Impossible", "imageUrl": globalMovieDatabase["Mission Impossible"]!["imageUrl"]},
    {"title": "Lay Bhari", "imageUrl": globalMovieDatabase["Lay Bhari"]!["imageUrl"]},
  ];

  final List<Map<String, String>> sciFiMovies = [
    {"title": "Interstellar", "imageUrl": globalMovieDatabase["Interstellar"]!["imageUrl"]},
    {"title": "Matrix", "imageUrl": globalMovieDatabase["Matrix"]!["imageUrl"]},
    {"title": "Ra-One", "imageUrl": globalMovieDatabase["Ra-One"]!["imageUrl"]},
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _carouselTimer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < trendingMovies.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(_currentPage, duration: const Duration(milliseconds: 1000), curve: Curves.fastOutSlowIn);
      }
    });
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.transparent, // Let the NeonBackground show through
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0,
        toolbarHeight: 80, 
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.movie_filter_rounded, color: Color(0xFFB026FF), size: 28),
                SizedBox(width: 10),
                Text("MovieBar", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
              ]
            ),
            SizedBox(height: 6),
            Text("Find your next favorite film", style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            
            AspectRatio(
              aspectRatio: screenWidth > 800 ? 21 / 9 : 4 / 3, 
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (int page) => setState(() => _currentPage = page),
                itemCount: trendingMovies.length,
                itemBuilder: (context, index) {
                  final movie = trendingMovies[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetailScreen(
                        movieTitle: movie["title"], 
                        imageUrl: movie["imageUrl"]
                      )));
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1), 
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.8), blurRadius: 20, offset: const Offset(0, 10))],
                        image: DecorationImage(
                          image: NetworkImage(movie["imageUrl"]),
                          fit: BoxFit.cover,
                          alignment: Alignment.center, 
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 0, left: 0, right: 0,
                            child: Container(
                              height: screenWidth > 800 ? 250 : 200, 
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                                gradient: LinearGradient(
                                  colors: [Colors.transparent, const Color(0xFF050505).withOpacity(0.8), const Color(0xFF050505)],
                                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                                )
                              ),
                              padding: const EdgeInsets.all(25),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(color: const Color(0xFFB026FF), borderRadius: BorderRadius.circular(8)),
                                    child: const Text("TRENDING NOW", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(movie["title"], style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5)),
                                  const SizedBox(height: 6),
                                  Text(movie["desc"], style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                trendingMovies.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300), margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 6, width: _currentPage == index ? 24 : 6,
                  decoration: BoxDecoration(color: _currentPage == index ? const Color(0xFFB026FF) : Colors.white24, borderRadius: BorderRadius.circular(4)),
                ),
              ),
            ),
            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Explore Genres", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 0.5)),
                  const SizedBox(height: 15),
                  GridView.count(
                    shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: screenWidth > 800 ? 4 : 2,
                    crossAxisSpacing: 15, mainAxisSpacing: 15, childAspectRatio: 2.5,
                    children: [
                      _buildLargeGenreCard("Action", "https://wallpapers.com/images/featured/john-wick-jeaidqurrfx52d3u.jpg", const [Color(0xFFFF0055), Color(0xFF80002A)]),
                      _buildLargeGenreCard("Sci-Fi", "https://images.squarespace-cdn.com/content/v1/5fbc4a62c2150e62cfcb09aa/1613866127038-C4YJRGV1KBA0XO3C1GTL/Mustafar.jpg", const [Color(0xFF00FFCC), Color(0xFF008066)]),
                      _buildLargeGenreCard("Romance", "https://s.yimg.com/ny/api/res/1.2/fITvFHu.LJ0KJRR.39bRMw--/YXBwaWQ9aGlnaGxhbmRlcjt3PTEyNDI7aD02OTk7Y2Y9d2VicA--/https://media.zenfs.com/en/cinemablend_388/b90daa9b49568ee61aeac37896cab332", const [Color(0xFFB026FF), Color(0xFF5E00D4)]),
                      _buildLargeGenreCard("Comedy", "https://www.hollywoodreporterindia.com/_next/image?url=https%3A%2F%2Fcdn.hollywoodreporterindia.com%2Farticle%2F2025-05-27T09%253A54%253A23.306Z-WhatsApp%2520Image%25202025-05-19%2520at%252012.33.19%2520PM.jpeg&w=3840&q=75", const [Color(0xFF39FF14), Color(0xFF1A800A)]),
                    ],
                  ),
                ],
              ),
            ),
                  
            _buildMovieRow(context, "Action Thrillers", actionMovies),
            const SizedBox(height: 25),
            _buildMovieRow(context, "Mind-Bending Sci-Fi", sciFiMovies),
          ],
        ),
      ),
    );
  }

  Widget _buildLargeGenreCard(String title, String bgImageUrl, List<Color> gradientColors) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        boxShadow: [BoxShadow(color: gradientColors.first.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material( 
          color: Colors.transparent,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(bgImageUrl, fit: BoxFit.cover),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [gradientColors.first.withOpacity(0.1), gradientColors.last.withOpacity(0.6)],
                    begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  )
                ),
              ),
              InkWell(
                onTap: () {}, 
                splashColor: Colors.white.withOpacity(0.3),
                highlightColor: Colors.white.withOpacity(0.1),
                child: Center(
                  child: Text(
                    title.toUpperCase(), 
                    style: const TextStyle(
                      fontWeight: FontWeight.w900, 
                      fontSize: 22, 
                      letterSpacing: 3.0, 
                      color: Colors.white,
                      shadows: [Shadow(color: Colors.black87, blurRadius: 15, offset: Offset(0, 4))]
                    )
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMovieRow(BuildContext context, String categoryTitle, List<Map<String, String>> movies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(categoryTitle, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 0.5)),
              const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 18),
            ],
          ),
        ),
        SizedBox(
          height: 180, 
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetailScreen(
                    movieTitle: movie["title"]!, 
                    imageUrl: movie["imageUrl"]!
                  )));
                },
                child: Container(
                  width: 280, 
                  margin: const EdgeInsets.symmetric(horizontal: 7),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Hero(
                          tag: 'poster-${movie["title"]}',
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white.withOpacity(0.1)),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10, offset: const Offset(0, 4))],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                movie["imageUrl"]!,
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                                width: double.infinity,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text(movie["title"]!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white, letterSpacing: 0.3), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ==========================================
// 3. DISCOVER SCREEN 
// ==========================================
class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> tonightsPicks = [
    {"title": "The Godfather", "imageUrl": globalMovieDatabase["The Godfather"]!["imageUrl"]},
    {"title": "Fight Club", "imageUrl": globalMovieDatabase["Fight Club"]!["imageUrl"]},
  ];

  final List<Map<String, String>> hiddenGems = [
    {"title": "Dead Poets Society", "imageUrl": globalMovieDatabase["Dead Poets Society"]!["imageUrl"]},
  ];

  final List<Map<String, String>> awardWinners = [
    {"title": "Oppenheimer", "imageUrl": globalMovieDatabase["Oppenheimer"]!["imageUrl"]},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openAdvancedFilters(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 800) {
      showModalBottomSheet(context: context, backgroundColor: Colors.transparent, isScrollControlled: true, builder: (context) => const AdvancedFilterPanel(isMobile: true));
    } else {
      Scaffold.of(context).openEndDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      endDrawer: const AdvancedFilterPanel(isMobile: false),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: const Text("Discover", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 28, letterSpacing: 0.5)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Search titles, actors, directors...", hintStyle: const TextStyle(color: Colors.white54),
                        prefixIcon: const Icon(Icons.search, color: Colors.white70),
                        filled: true, fillColor: const Color(0xFF0D1117).withOpacity(0.8),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Builder(
                    builder: (context) => InkWell(
                      onTap: () => _openAdvancedFilters(context),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 55, width: 55,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D1117).withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: const Icon(Icons.tune_rounded, color: Color(0xFFB026FF), size: 28),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            _buildDiscoverRow(context, "Tonight's Picks", tonightsPicks),
            const SizedBox(height: 25),
            _buildDiscoverRow(context, "Hidden Gems", hiddenGems),
            const SizedBox(height: 25),
            _buildDiscoverRow(context, "Award Winners", awardWinners),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscoverRow(BuildContext context, String categoryTitle, List<Map<String, String>> movies) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(categoryTitle, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 0.5)),
              const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 18),
            ],
          ),
        ),
        SizedBox(
          height: 180, 
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetailScreen(
                    movieTitle: movie["title"]!, 
                    imageUrl: movie["imageUrl"]!
                  )));
                },
                child: Container(
                  width: 280, 
                  margin: const EdgeInsets.symmetric(horizontal: 7),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Hero(
                          tag: 'poster-${movie["title"]}',
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white.withOpacity(0.1)),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10, offset: const Offset(0, 4))],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                movie["imageUrl"]!,
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                                width: double.infinity,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text(movie["title"]!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white, letterSpacing: 0.3), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ==========================================
// 4. THE ADVANCED FILTER PANEL
// ==========================================
class AdvancedFilterPanel extends StatefulWidget {
  final bool isMobile;
  const AdvancedFilterPanel({super.key, required this.isMobile});

  @override
  State<AdvancedFilterPanel> createState() => _AdvancedFilterPanelState();
}

class _AdvancedFilterPanelState extends State<AdvancedFilterPanel> {
  RangeValues _decadeRange = const RangeValues(1980, 2024);
  Set<String> selectedGenres = {};
  Set<String> selectedAwards = {};
  String selectedRating = "";

  void _toggleSelection(Set<String> set, String item) {
    setState(() {
      if (set.contains(item)) set.remove(item);
      else set.add(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = widget.isMobile ? const BorderRadius.vertical(top: Radius.circular(30)) : const BorderRadius.horizontal(left: Radius.circular(30));
    final panelWidth = widget.isMobile ? double.infinity : 400.0;
    final panelHeight = widget.isMobile ? MediaQuery.of(context).size.height * 0.90 : double.infinity;

    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          width: panelWidth, height: panelHeight, padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: const Color(0xFF050505).withOpacity(0.8), 
            border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.5)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Advanced Filters", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 0.5)),
                  IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context))
                ],
              ),
              const Divider(color: Colors.white24, height: 30),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle("Decade"),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("${_decadeRange.start.round()}", style: const TextStyle(color: Colors.white70)), Text("${_decadeRange.end.round()}", style: const TextStyle(color: Colors.white70))]),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(activeTrackColor: const Color(0xFFB026FF), inactiveTrackColor: Colors.white12, thumbColor: const Color(0xFFB026FF), overlayColor: const Color(0xFFB026FF).withOpacity(0.2)),
                        child: RangeSlider(values: _decadeRange, min: 1950, max: 2024, divisions: 74, labels: RangeLabels("${_decadeRange.start.round()}", "${_decadeRange.end.round()}"), onChanged: (RangeValues values) => setState(() => _decadeRange = values)),
                      ),
                      const SizedBox(height: 25),
                      _buildSectionTitle("Genre"),
                      _buildPillGrid(["Action", "Sci-Fi", "Romance", "Thriller", "Comedy", "Fantasy", "Drama"], selectedGenres),
                      const SizedBox(height: 25),
                      _buildSectionTitle("Award Badges"),
                      _buildPillGrid(["Oscar Winner", "Golden Globe", "BAFTA"], selectedAwards),
                      const SizedBox(height: 25),
                      _buildSectionTitle("Official Ratings"),
                      _buildSingleSelectPillGrid(
                        ["PG", "PG-13", "R", "NC-17", "A", "U/A"], 
                        selectedRating,
                        (value) => setState(() => selectedRating = selectedRating == value ? "" : value)
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFB026FF), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 18), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), elevation: 10, shadowColor: const Color(0xFFB026FF).withOpacity(0.5)),
                  onPressed: () { Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Applying Filters...'))); },
                  child: const Text("Show Results", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1.0)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Padding(padding: const EdgeInsets.only(bottom: 12.0), child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5)));

  Widget _buildPillGrid(List<String> options, Set<String> selectedSet) {
    return Wrap(
      spacing: 12, runSpacing: 12,
      children: options.map((option) {
        bool isSelected = selectedSet.contains(option);
        return GestureDetector(
          onTap: () => _toggleSelection(selectedSet, option),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200), padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(color: isSelected ? const Color(0xFFB026FF).withOpacity(0.2) : const Color(0xFF0D1117), border: Border.all(color: isSelected ? const Color(0xFFB026FF) : Colors.white.withOpacity(0.1)), borderRadius: BorderRadius.circular(20)),
            child: Text(option, style: TextStyle(color: isSelected ? Colors.white : Colors.white70, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSingleSelectPillGrid(List<String> options, String selectedValue, Function(String) onSelect) {
    return Wrap(
      spacing: 12, runSpacing: 12,
      children: options.map((option) {
        bool isSelected = selectedValue == option;
        return GestureDetector(
          onTap: () => onSelect(option),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200), padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(color: isSelected ? const Color(0xFFB026FF).withOpacity(0.2) : const Color(0xFF0D1117), border: Border.all(color: isSelected ? const Color(0xFFB026FF) : Colors.white.withOpacity(0.1)), borderRadius: BorderRadius.circular(20)),
            child: Text(option, style: TextStyle(color: isSelected ? Colors.white : Colors.white70, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
          ),
        );
      }).toList(),
    );
  }
}

// ==========================================
// 5. MOVIE DETAIL SCREEN 
// ==========================================
class MovieDetailScreen extends StatefulWidget {
  final String movieTitle;
  final String imageUrl;

  const MovieDetailScreen({super.key, required this.movieTitle, required this.imageUrl});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  int selectedRating = 0;
  final TextEditingController _reviewController = TextEditingController();

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void submitReview() {
    if (_reviewController.text.isNotEmpty && selectedRating > 0) {
      final newReviews = List<Map<String, dynamic>>.from(globalReviews.value);
      newReviews.insert(0, {
        "movie": widget.movieTitle,
        "rating": selectedRating,
        "text": _reviewController.text
      });
      globalReviews.value = newReviews;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Review saved to Profile!')));
      _reviewController.clear();
      setState(() => selectedRating = 0);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please add a rating and review.')));
    }
  }

  void _playTrailer(String? trailerId) {
    if (trailerId == null || trailerId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Trailer not available for this title.')));
      return;
    }

    final ytController = YoutubePlayerController.fromVideoId(
      videoId: trailerId,
      autoPlay: true,
      params: const YoutubePlayerParams(showFullscreenButton: true),
    );

    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 800, 
            constraints: const BoxConstraints(maxHeight: 450), 
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: Colors.white.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                Center(
                  child: YoutubePlayer(controller: ytController),
                ),
                Positioned(
                  top: 10, right: 10,
                  child: IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.white, size: 32),
                    onPressed: () => Navigator.pop(context),
                  )
                )
              ]
            )
          )
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    
    final movieData = globalMovieDatabase[widget.movieTitle] ?? globalMovieDatabase["default"]!;
    final castList = movieData["cast"] as List;

    return Scaffold(
      backgroundColor: const Color(0xFF050505), // Detail screen stays dark to highlight poster
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.white)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'poster-${widget.movieTitle}',
                child: AspectRatio(
                  aspectRatio: screenWidth > 800 ? 21 / 9 : 4 / 3, 
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.8), blurRadius: 30, offset: const Offset(0, 15))],
                      image: DecorationImage(
                        image: NetworkImage(widget.imageUrl),
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                      )
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(widget.movieTitle, style: const TextStyle(fontSize: 38, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5, height: 1.1))),
                  
                  ValueListenableBuilder<Set<String>>(
                    valueListenable: globalWatchlist,
                    builder: (context, watchlist, child) {
                      bool isSaved = watchlist.contains(widget.movieTitle);
                      return IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          final newSet = Set<String>.from(watchlist);
                          if (isSaved) {
                            newSet.remove(widget.movieTitle);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Removed from Watchlist')));
                          } else {
                            newSet.add(widget.movieTitle);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to Watchlist')));
                          }
                          globalWatchlist.value = newSet;
                        }, 
                        icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border, color: const Color(0xFFB026FF), size: 36)
                      );
                    }
                  )
                ],
              ),
              const SizedBox(height: 10),
              Text("${movieData['year']} • ${movieData['duration']} • ${movieData['genre']} • ${movieData['rating']}", style: const TextStyle(fontSize: 16, color: Colors.white70, fontWeight: FontWeight.w600)),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB026FF), 
                    foregroundColor: Colors.white, 
                    padding: const EdgeInsets.symmetric(vertical: 18), 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))
                  ),
                  onPressed: () => _playTrailer(movieData["trailerId"]), 
                  icon: const Icon(Icons.play_arrow_rounded, size: 32), 
                  label: const Text("Watch Trailer", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D1117).withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.05))
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(child: _buildMetaColumn("Director", movieData['director'])),
                    Expanded(child: _buildMetaColumn("Origin", movieData['origin'])),
                    Expanded(child: _buildMetaColumn("Awards", movieData['awards'])),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              const Text("Synopsis", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 0.5)),
              const SizedBox(height: 15),
              Text(
                movieData['synopsis'], 
                style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.white70)
              ),
              const SizedBox(height: 40),
              const Text("Top Cast", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 0.5)),
              const SizedBox(height: 20),
              SizedBox(
                height: 130,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: castList.length,
                  itemBuilder: (context, index) {
                    final actor = castList[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 25.0),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white.withOpacity(0.1), width: 2)),
                            child: CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(actor["image"]!),
                              backgroundColor: const Color(0xFF0D1117),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(actor["name"]!, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    );
                  }
                ),
              ),
              const SizedBox(height: 30),
              const Divider(color: Colors.white12),
              const SizedBox(height: 30),
              const Text("Rate this title", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 0.5)),
              const SizedBox(height: 15),
              Row(
                children: List.generate(5, (index) => IconButton(
                  icon: Icon(index < selectedRating ? Icons.star : Icons.star_border, color: const Color(0xFFB026FF), size: 40),
                  onPressed: () => setState(() => selectedRating = index + 1),
                )),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _reviewController, maxLines: 3, style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Write your review here...", hintStyle: const TextStyle(color: Colors.white54),
                  filled: true, fillColor: const Color(0xFF0D1117).withOpacity(0.8),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFB026FF), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  onPressed: submitReview, child: const Text("Post Review", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetaColumn(String title, String value) {
    return Column(
      children: [
        Text(title.toUpperCase(), style: const TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        const SizedBox(height: 8),
        Text(value, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w900)),
      ],
    );
  }
}

// ==========================================
// 6. WATCHLIST SCREEN
// ==========================================
class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0, toolbarHeight: 80,
        title: const Text("My Watchlist", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 28, letterSpacing: 0.5)),
      ),
      body: ValueListenableBuilder<Set<String>>(
        valueListenable: globalWatchlist,
        builder: (context, watchlist, child) {
          if (watchlist.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_border, size: 80, color: Colors.white24),
                  const SizedBox(height: 20),
                  const Text("Your watchlist is empty", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  const Text("Save movies you want to watch later.", style: TextStyle(color: Colors.white54, fontSize: 16)),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 120),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: screenWidth > 800 ? 4 : 2,
              childAspectRatio: 3 / 4, 
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            itemCount: watchlist.length,
            itemBuilder: (context, index) {
              String movieTitle = watchlist.elementAt(index);
              final movieData = globalMovieDatabase[movieTitle] ?? globalMovieDatabase["default"]!;
              
              return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetailScreen(
                    movieTitle: movieTitle, 
                    imageUrl: movieData["imageUrl"]
                  )));
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                    image: DecorationImage(
                      image: NetworkImage(movieData["imageUrl"]),
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    )
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black.withOpacity(0.9)],
                        begin: Alignment.topCenter, end: Alignment.bottomCenter,
                      )
                    ),
                    padding: const EdgeInsets.all(15),
                    alignment: Alignment.bottomLeft,
                    child: Text(movieTitle, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 0.5)),
                  ),
                ),
              );
            },
          );
        }
      ),
    );
  }
}

// ==========================================
// 7. PROFILE SCREEN 
// ==========================================
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0, toolbarHeight: 80,
        title: const Text("My Profile", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 28, letterSpacing: 0.5)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [Color(0xFFB026FF), Color(0xFF5E00D4)])),
                  child: const CircleAvatar(
                    radius: 45,
                    backgroundColor: Color(0xFF0D1117),
                    child: Icon(Icons.person_pin, size: 45, color: Colors.white),
                  ),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Yash87", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 0.5)),
                    const SizedBox(height: 4),
                    Text("Premium Member • Joined 2024", style: TextStyle(fontSize: 14, color: Colors.white54, fontWeight: FontWeight.w600)),
                  ],
                )
              ],
            ),
            const SizedBox(height: 50),

            const Text("Continue Watching", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 0.5)),
            const SizedBox(height: 20),
            _buildContinueWatchingCard("Dhurandar 2", 0.7, "1h 12m remaining"),
            const SizedBox(height: 15),
            _buildContinueWatchingCard("The Godfather", 0.3, "2h 05m remaining"),
            const SizedBox(height: 50),

            const Text("My Recent Reviews", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 0.5)),
            const SizedBox(height: 20),
            
            ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: globalReviews,
              builder: (context, reviews, child) {
                if (reviews.isEmpty) {
                  return const Text("You haven't written any reviews yet.", style: TextStyle(color: Colors.white54));
                }
                
                return Column(
                  children: reviews.map((review) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D1117).withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.05))
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(review["movie"], style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Colors.white)),
                              Row(
                                children: List.generate(5, (starIndex) => Icon(
                                  starIndex < review["rating"] ? Icons.star : Icons.star_border, 
                                  color: const Color(0xFFB026FF), size: 18
                                )),
                              )
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(review["text"], style: const TextStyle(color: Colors.white70, height: 1.5, fontSize: 15)),
                        ],
                      ),
                    );
                  }).toList(),
                );
              }
            )
          ],
        ),
      ),
    );
  }

  Widget _buildContinueWatchingCard(String title, double progress, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117).withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Colors.white)),
              const Icon(Icons.play_circle_fill, color: Color(0xFFB026FF), size: 32),
            ],
          ),
          const SizedBox(height: 8),
          Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: const Color(0xFF050505),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFB026FF)),
            borderRadius: BorderRadius.circular(10),
            minHeight: 8,
          )
        ],
      ),
    );
  }
}