import 'package:flutter/material.dart';

void main() {
  runApp(const MoodStreamApp());
}

class MoodStreamApp extends StatelessWidget {
  const MoodStreamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoodStream',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF1E1C1A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFE6B17E),
          surface: Color(0xFF2C2826),
        ),
        fontFamily: 'Nunito',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFFF0E6D2)),
          bodyMedium: TextStyle(color: Color(0xFFF0E6D2)),
        ),
      ),
      home: const MainNavigator(),
    );
  }
}

// ==========================================
// 1. MAIN NAVIGATOR (4 Bottom Tabs Now!)
// ==========================================
class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _selectedIndex = 0;

  // The 4 main screens of your app
  final List<Widget> _screens = [
    const HomeScreen(),
    const DiscoverScreen(), // NEW: Search & Genres
    const WatchlistScreen(), // UPGRADED: Actual Watchlist UI
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05), width: 1)),
        ),
        child: BottomNavigationBar(
          backgroundColor: const Color(0xFF1E1C1A),
          selectedItemColor: const Color(0xFFE6B17E),
          unselectedItemColor: const Color(0xFF5C554F),
          type: BottomNavigationBarType.fixed, // Needed for 4+ items
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Discover'),
            BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Watchlist'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 2. HOME SCREEN (Moods & Movies)
// ==========================================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedMood = "None";

  void fetchMoviesByMood(String mood) {
    setState(() {
      selectedMood = mood;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Good Evening,", style: TextStyle(color: Color(0xFFA89F91), fontSize: 16)),
            Text("What's your vibe?", style: TextStyle(color: Color(0xFFE6B17E), fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: screenWidth > 800 ? 4 : 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 2.5,
                children: [
                  _buildMoodCard("Relaxed", "🔥", const [Color(0xFF8B5A2B), Color(0xFF4A3018)], () => fetchMoviesByMood("Cozy")),
                  _buildMoodCard("Thrill", "⚡", const [Color(0xFF2B548B), Color(0xFF182A4A)], () => fetchMoviesByMood("Adrenaline")),
                  _buildMoodCard("Uplift", "☀️", const [Color(0xFF8B732B), Color(0xFF4A3E18)], () => fetchMoviesByMood("Happy")),
                  _buildMoodCard("Deep", "🌧️", const [Color(0xFF4A4A4A), Color(0xFF242424)], () => fetchMoviesByMood("Melancholy")),
                ],
              ),
              
              const SizedBox(height: 40),
              
              if (selectedMood != "None") ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Perfect for $selectedMood",
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFF0E6D2)),
                    ),
                    const Icon(Icons.arrow_forward_ios, color: Color(0xFF5C554F), size: 16),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 260,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildMovieCard(context, "Autumn Whispers", "🍂", "1h 45m", const [Color(0xFF5C3A21), Color(0xFF2C1E14)]),
                      _buildMovieCard(context, "The Cabin", "🪵", "2h 10m", const [Color(0xFF2C3E2D), Color(0xFF151E16)]),
                      _buildMovieCard(context, "Midnight Rain", "☕", "1h 30m", const [Color(0xFF2D3A4A), Color(0xFF161D25)]),
                    ],
                  ),
                )
              ] else ...[
                 Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Column(
                      children: [
                        Icon(Icons.movie_filter_rounded, size: 60, color: Colors.white.withOpacity(0.1)),
                        const SizedBox(height: 15),
                        Text("Select a mood above to unlock movies.", style: TextStyle(color: Colors.white.withOpacity(0.3))),
                      ],
                    ),
                  ),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoodCard(String title, String emoji, List<Color> gradientColors, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradientColors, begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: gradientColors[0].withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieCard(BuildContext context, String title, String emoji, String duration, List<Color> gradientColors) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => MovieDetailScreen(movieTitle: title, emoji: emoji, gradientColors: gradientColors)));
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradientColors, begin: Alignment.topCenter, end: Alignment.bottomCenter),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 70)),
            const SizedBox(height: 30),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white), textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), borderRadius: BorderRadius.circular(10)),
              child: Text(duration, style: const TextStyle(color: Color(0xFFE6B17E), fontSize: 12)),
            )
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 3. NEW: DISCOVER SCREEN (Search & Genres)
// ==========================================
class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Discover", style: TextStyle(color: Color(0xFFE6B17E), fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search movies, series, actors...",
                hintStyle: const TextStyle(color: Color(0xFF5C554F)),
                prefixIcon: const Icon(Icons.search, color: Color(0xFFE6B17E)),
                filled: true,
                fillColor: const Color(0xFF2C2826),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
              onSubmitted: (value) {
                // Here is where you trigger the SQL: SELECT * FROM Content WHERE title LIKE '%value%'
                print("Searching database for: $value");
              },
            ),
            const SizedBox(height: 40),
            
            // Genres Section
            const Text("Explore by Genre", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFF0E6D2))),
            const SizedBox(height: 15),
            
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildGenreChip("Sci-Fi", Icons.rocket_launch),
                _buildGenreChip("Romance", Icons.favorite),
                _buildGenreChip("Thriller", Icons.visibility),
                _buildGenreChip("Comedy", Icons.sentiment_very_satisfied),
                _buildGenreChip("Fantasy", Icons.auto_awesome),
                _buildGenreChip("Documentary", Icons.camera_alt),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenreChip(String label, IconData icon) {
    return InkWell(
      onTap: () {
        // Trigger SQL: SELECT * FROM Content JOIN Content_Genre ... WHERE genre_name = 'label'
        print("Filtering by Genre: $label");
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: const Color(0xFF5C554F)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFFE6B17E), size: 18),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Color(0xFFF0E6D2))),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 4. NEW: WATCHLIST SCREEN
// ==========================================
class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("My Watchlist", style: TextStyle(color: Color(0xFFE6B17E), fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildWatchlistTile("The Silent Sea", "Sci-Fi • 2h 15m", "🌊"),
          _buildWatchlistTile("Autumn Whispers", "Cozy • 1h 45m", "🍂"),
          _buildWatchlistTile("Neon Dreams", "Cyberpunk • Series", "🌆"),
        ],
      ),
    );
  }

  Widget _buildWatchlistTile(String title, String subtitle, String emoji) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2826),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            height: 70, width: 60,
            decoration: BoxDecoration(color: const Color(0xFF1E1C1A), borderRadius: BorderRadius.circular(10)),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 30))),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 5),
                Text(subtitle, style: const TextStyle(color: Color(0xFFA89F91), fontSize: 13)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.play_circle_fill, color: Color(0xFFE6B17E), size: 36),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}

// ==========================================
// 5. MOVIE DETAIL SCREEN (Review Logic)
// ==========================================
class MovieDetailScreen extends StatefulWidget {
  final String movieTitle;
  final String emoji;
  final List<Color> gradientColors;

  const MovieDetailScreen({super.key, required this.movieTitle, required this.emoji, required this.gradientColors});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  int selectedRating = 0;
  final TextEditingController _reviewController = TextEditingController();

  void submitReview() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Review saved! (Simulated DB Insert)')));
    _reviewController.clear();
    setState(() => selectedRating = 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Color(0xFFE6B17E))),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 250, width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: widget.gradientColors, begin: Alignment.topCenter, end: Alignment.bottomCenter),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: widget.gradientColors[0].withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 10))],
                ),
                child: Center(child: Text(widget.emoji, style: const TextStyle(fontSize: 100))),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.movieTitle, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFFF0E6D2))),
                  IconButton(onPressed: (){}, icon: const Icon(Icons.bookmark_border, color: Color(0xFFE6B17E), size: 30))
                ],
              ),
              const SizedBox(height: 10),
              const Text("2024 • 1h 45m • Cozy • ⭐ 4.8/5", style: TextStyle(fontSize: 16, color: Color(0xFFA89F91))),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE6B17E), foregroundColor: const Color(0xFF1E1C1A), padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                  onPressed: () {}, icon: const Icon(Icons.play_arrow_rounded, size: 28), label: const Text("Play Movie", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 30),
              const Text("A gentle breeze, a crackling fire, and a mystery that unfolds at the pace of falling leaves. Perfect for a quiet night in.", style: TextStyle(fontSize: 16, height: 1.6, color: Color(0xFFF0E6D2))),
              const SizedBox(height: 40),
              const Text("Add a Review", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFE6B17E))),
              const SizedBox(height: 15),
              Row(
                children: List.generate(5, (index) => IconButton(
                  icon: Icon(index < selectedRating ? Icons.star : Icons.star_border, color: const Color(0xFFE6B17E), size: 36),
                  onPressed: () => setState(() => selectedRating = index + 1),
                )),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _reviewController, maxLines: 3, style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "How did it make you feel?", hintStyle: const TextStyle(color: Color(0xFF5C554F)),
                  filled: true, fillColor: const Color(0xFF2C2826),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 15),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4A3018), foregroundColor: const Color(0xFFE6B17E), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  onPressed: submitReview, child: const Text("Submit"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 6. PROFILE SCREEN (Watch History)
// ==========================================
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: const Text("My Profile", style: TextStyle(color: Color(0xFFE6B17E), fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 40, backgroundColor: const Color(0xFFE6B17E).withOpacity(0.2), child: const Icon(Icons.person, size: 40, color: Color(0xFFE6B17E))),
                const SizedBox(width: 20),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("NightOwl99", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                    Text("Joined Oct 2023", style: TextStyle(color: Color(0xFFA89F91))),
                  ],
                )
              ],
            ),
            const SizedBox(height: 40),
            const Text("Continue Watching", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFE6B17E))),
            const SizedBox(height: 15),
            _buildHistoryTile("Autumn Whispers", "Stopped at 45:12", 0.4),
            _buildHistoryTile("The Cabin", "Stopped at 1:12:00", 0.6),
            const SizedBox(height: 40),
            const Text("My Recent Reviews", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFE6B17E))),
            const SizedBox(height: 15),
            _buildMyReviewTile("Fireside", "⭐⭐⭐⭐⭐", "So relaxing!"),
            _buildMyReviewTile("Midnight Rain", "⭐⭐⭐⭐", "Great atmosphere, slow start."),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryTile(String title, String progressText, double progress) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15), padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: const Color(0xFF2C2826), borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
              const Icon(Icons.play_circle_fill, color: Color(0xFFE6B17E)),
            ],
          ),
          const SizedBox(height: 10),
          Text(progressText, style: const TextStyle(color: Color(0xFFA89F91), fontSize: 12)),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: progress, backgroundColor: Colors.black, color: const Color(0xFFE6B17E), borderRadius: BorderRadius.circular(5)),
        ],
      ),
    );
  }

  Widget _buildMyReviewTile(String movie, String stars, String comment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(border: Border.all(color: Colors.white.withOpacity(0.05)), borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(movie, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFE6B17E))), Text(stars)]),
          const SizedBox(height: 8),
          Text(comment, style: const TextStyle(color: Color(0xFFF0E6D2))),
        ],
      ),
    );
  }
}