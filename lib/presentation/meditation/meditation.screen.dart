import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:my_spacing/my_spacing.dart';

import 'package:Mentora/infrastructure/theme/theme.dart';
import 'package:Mentora/infrastructure/navigation/routes.dart';

import 'widgets/meditation_header.dart';
import 'widgets/meditation_search_bar.dart';
import 'widgets/meditation_filter_chips.dart';
import 'widgets/meditation_section_title.dart';
import 'widgets/featured_meditation_card.dart';
import 'widgets/meditation_card.dart';
import 'widgets/meditation_empty_view.dart';
import 'widgets/meditation_loading.dart';
import 'widgets/meditation_session.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isLoading = true;
  final Set<String> _favoritedIds = {'1', '3'}; // Pre-populate some favorites

  @override
  void initState() {
    super.initState();
    // Simulate loading for loading state presentation
    Timer(const Duration(milliseconds: 700), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  // Toggle favorite status
  void _toggleFavorite(String id) {
    setState(() {
      if (_favoritedIds.contains(id)) {
        _favoritedIds.remove(id);
      } else {
        _favoritedIds.add(id);
      }
    });
  }

  // Filter list of sessions based on selection and query
  List<MeditationSession> get _filteredSessions {
    return mockMeditationSessions.where((session) {
      final matchesCategory = _selectedCategory == 'All' ||
          session.category.toLowerCase() == _selectedCategory.toLowerCase();
      final matchesQuery = _searchQuery.isEmpty ||
          session.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          session.category.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();
  }

  // Filter list of featured sessions
  List<MeditationSession> get _featuredSessions {
    return mockMeditationSessions.where((session) {
      if (!session.isFeatured) return false;
      final matchesCategory = _selectedCategory == 'All' ||
          session.category.toLowerCase() == _selectedCategory.toLowerCase();
      final matchesQuery = _searchQuery.isEmpty ||
          session.title.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      body: SafeArea(
        top: false, // SliverAppBar handles top safe area
        child: _isLoading
            ? Column(
                children: [
                  AppBar(
                    backgroundColor: Theme.of(context).primaryColorLight,
                    elevation: 0,
                    leading: const Center(child: BackButton()),
                    title: Text("Meditation", style: h2),
                    centerTitle: true,
                  ),
                  const Expanded(child: MeditationLoading()),
                ],
              )
            : CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // App Bar
                  MeditationHeader(
                    onSearchTap: () {
                      _searchFocusNode.requestFocus();
                    },
                  ),

                  // Search Bar & Filter Chips & Featured Section
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Search Input
                        MeditationSearchBar(
                          controller: _searchController,
                          focusNode: _searchFocusNode,
                          onChanged: (val) {
                            setState(() {
                              _searchQuery = val;
                            });
                          },
                        ),
                        Spacing.s8.h,

                        // Horizontal Filter Chips
                        MeditationFilterChips(
                          selectedCategory: _selectedCategory,
                          onCategorySelected: (cat) {
                            setState(() {
                              _selectedCategory = cat;
                            });
                          },
                        ),
                        Spacing.s16.h,

                        // Featured Section (Hide if empty)
                        if (_featuredSessions.isNotEmpty) ...[
                          const MeditationSectionTitle(title: "Featured"),
                          SizedBox(
                            height: 180.h,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.symmetric(horizontal: Spacing.s16.value.w),
                              itemCount: _featuredSessions.length,
                              itemBuilder: (context, index) {
                                final session = _featuredSessions[index];
                                return FeaturedMeditationCard(
                                  session: session,
                                  isFavorited: _favoritedIds.contains(session.id),
                                  onTap: () {
                                    Get.toNamed(
                                      Routes.MEDITATION_PLAYER,
                                      arguments: session,
                                    );
                                  },
                                  onFavoriteTap: () => _toggleFavorite(session.id),
                                );
                              },
                            ),
                          ),
                          Spacing.s16.h,
                        ],

                        // All Meditations Title
                        if (_filteredSessions.isNotEmpty)
                          const MeditationSectionTitle(title: "All Meditations"),
                      ],
                    ),
                  ),

                  // All Meditations list
                  if (_filteredSessions.isNotEmpty)
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final session = _filteredSessions[index];
                          return MeditationCard(
                            session: session,
                            isFavorited: _favoritedIds.contains(session.id),
                            onTap: () {
                              Get.toNamed(
                                Routes.MEDITATION_PLAYER,
                                arguments: session,
                              );
                            },
                            onFavoriteTap: () => _toggleFavorite(session.id),
                          );
                        },
                        childCount: _filteredSessions.length,
                      ),
                    )
                  else
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: 40.h),
                        child: const MeditationEmptyView(),
                      ),
                    ),

                  // Extra bottom spacing
                  SliverToBoxAdapter(
                    child: Spacing.s32.h,
                  ),
                ],
              ),
      ),
    );
  }
}
