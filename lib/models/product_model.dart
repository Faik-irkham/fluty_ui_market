import 'package:flutter/material.dart';

/// Model data produk Fluty Market dengan gambar asli (Unsplash) & detail lengkap berbahasa Indonesia.
class LuxuryProduct {
  final String id;
  final String name;
  final String originalName; // Nama asli / deskripsi jenaka
  final String tagline;
  final double price;
  final String imageUrl;
  final List<String> galleryImages;
  final List<Color> gradientColors;
  final String badge;
  final double rating;
  final int reviewCount;
  final String description;
  bool isFavorited;

  LuxuryProduct({
    required this.id,
    required this.name,
    required this.originalName,
    required this.tagline,
    required this.price,
    required this.imageUrl,
    required this.galleryImages,
    required this.gradientColors,
    required this.badge,
    required this.rating,
    required this.reviewCount,
    required this.description,
    this.isFavorited = false,
  });

  /// Format harga ke format Rupiah: Rp 18.500.000
  String get formattedPrice {
    final str = price.toStringAsFixed(0);
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
      count++;
    }
    return 'Rp ${buffer.toString().split('').reversed.join()}';
  }
}

/// Daftar 8 produk unik eksklusif di Fluty Market.
final List<LuxuryProduct> luxuryProducts = [
  LuxuryProduct(
    id: '1',
    name: 'Kayu Lapuk Artistik',
    originalName: 'Setumpuk Batang Kayu Lapuk',
    tagline: 'Dipilih langsung dari pelapukan alami halaman belakang dengan patina organik.',
    price: 18500000,
    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRibnEewe8oAZ6maoq-arqdbjpoWIF_mCVMLLQPCsFnyg&s=10',
    galleryImages: [
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRibnEewe8oAZ6maoq-arqdbjpoWIF_mCVMLLQPCsFnyg&s=10',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRibnEewe8oAZ6maoq-arqdbjpoWIF_mCVMLLQPCsFnyg&s=10',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRibnEewe8oAZ6maoq-arqdbjpoWIF_mCVMLLQPCsFnyg&s=10',
    ],
    gradientColors: [const Color(0xFF92400E), const Color(0xFF451A03)],
    badge: 'TERLARIS',
    rating: 4.9,
    reviewCount: 342,
    description: 'Setiap batang Kayu Lapuk Artistik dipanen dengan cermat dari lantai hutan murni, bersertifikat memiliki pelapukan autentik, bekas rayap, dan aura klasik yang tak tertandingi. Dirancang untuk kolektor seni modern yang menghargai keindahan estetika alami.',
  ),
  LuxuryProduct(
    id: '2',
    name: 'Batu Kali Zen Minimalis',
    originalName: 'Batu Kali Hitam Polos',
    tagline: 'Pemberat kertas arsitektural berat untuk eksekutif berkelas.',
    price: 4250000,
    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRyDQui0vVlLxaBRkZQh9Nytyn6vFdn1uaD4921pMkt-w&s=10',
    galleryImages: [
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRyDQui0vVlLxaBRkZQh9Nytyn6vFdn1uaD4921pMkt-w&s=10',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRyDQui0vVlLxaBRkZQh9Nytyn6vFdn1uaD4921pMkt-w&s=10',
    ],
    gradientColors: [const Color(0xFF1F2937), const Color(0xFF111827)],
    badge: 'PREMIUM',
    rating: 4.8,
    reviewCount: 215,
    description: 'Bersumber dari dasar sungai suci dan dipoles oleh aliran air selama ratusan tahun. Batu kali monolitik ini menghadirkan ketenangan di meja kerja eksekutif Anda sekaligus mengintimidasi kolega.',
  ),
  LuxuryProduct(
    id: '3',
    name: 'Udara Pegunungan Terperangkap',
    originalName: 'Gelas Kosong Terbalik',
    tagline: 'Ditangkap pada ketinggian 3.000 mdpl tepat saat matahari terbit.',
    price: 2999000,
    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRibthNPbZpHikduJhcllHMZTOmOIiXM4yvx6Ue7ZitFg&s=10',
    galleryImages: [
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRibthNPbZpHikduJhcllHMZTOmOIiXM4yvx6Ue7ZitFg&s=10',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRibthNPbZpHikduJhcllHMZTOmOIiXM4yvx6Ue7ZitFg&s=10',
    ],
    gradientColors: [const Color(0xFF0369A1), const Color(0xFF0C4A6E)],
    badge: 'TERBATAS',
    rating: 4.7,
    reviewCount: 189,
    description: 'Terbungkus dalam kristal tiup tangan berkualitas tinggi, wadah ini mengunci oksigen pegunungan murni. Hirup kesegarannya kapan pun tekanan pekerjaan kantor mencapai puncaknya.',
  ),
  LuxuryProduct(
    id: '4',
    name: 'Karet Gelang Berlapis Emas',
    originalName: 'Karet Gelang Kuning (Isi 1)',
    tagline: 'Polimer sintetis dengan regangan presisi tinggi.',
    price: 850000,
    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS282eWehVsoXVNQ5zvt1Vw7ea_mNuIi6XUUs0qiAp9BA&s=10',
    galleryImages: [
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS282eWehVsoXVNQ5zvt1Vw7ea_mNuIi6XUUs0qiAp9BA&s=10',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS282eWehVsoXVNQ5zvt1Vw7ea_mNuIi6XUUs0qiAp9BA&s=10',
    ],
    gradientColors: [const Color(0xFFD97706), const Color(0xFF78350F)],
    badge: 'LANGKA',
    rating: 4.9,
    reviewCount: 512,
    description: 'Cincin pengikat industri ikonik yang ditingkatkan ke standar horologi tinggi. Kekuatan tarik bersertifikat dijamin aman untuk menyatukan dokumen kontrak bernilai miliaran rupiah.',
  ),
  LuxuryProduct(
    id: '5',
    name: 'Kotak Penyimpanan Vintage',
    originalName: 'Kardus Mie Instan Bekas',
    tagline:
        'Wadah struktural ramah lingkungan dengan patina nostalgik autentik.',
    price: 7100000,
    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrcLtuyCXykS5avRIm6NtPTcgq2DfGWmYWlrjsnNlthw&s=10',
    galleryImages: [
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrcLtuyCXykS5avRIm6NtPTcgq2DfGWmYWlrjsnNlthw&s=10',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrcLtuyCXykS5avRIm6NtPTcgq2DfGWmYWlrjsnNlthw&s=10',
    ],
    gradientColors: [const Color(0xFF7C3AED), const Color(0xFF4C1D95)],
    badge: 'VINTAGE',
    rating: 4.6,
    reviewCount: 98,
    description: 'Puncak arsip minimalis. Menampilkan keahlian kardus bergelombang asli dengan tipografi pudar yang menceritakan kisah masa-masa lembur penuh inspirasi.',
  ),
  LuxuryProduct(
    id: '6',
    name: 'Sendok Ergonomis Ukiran',
    originalName: 'Sendok Plastik Bengkok',
    tagline: 'Peralatan makan bentuk termal kustom untuk jamuan avant-garde.',
    price: 1200000,
    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQfU0_bAsjSN_EhtNUHR0r48-LwmxLV90fw-dRpje2ahw&s=10',
    galleryImages: [
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQfU0_bAsjSN_EhtNUHR0r48-LwmxLV90fw-dRpje2ahw&s=10',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQfU0_bAsjSN_EhtNUHR0r48-LwmxLV90fw-dRpje2ahw&s=10',
    ],
    gradientColors: [const Color(0xFF0F766E), const Color(0xFF134E4A)],
    badge: 'EKSKLUSIF',
    rating: 4.8,
    reviewCount: 164,
    description: 'Dirancang oleh desainer industri independen. Kelengkungan aerodinamisnya menentang fisika makan tradisional, memastikan setiap suapan terasa seperti di restoran berbintang Michelin.',
  ),
  LuxuryProduct(
    id: '7',
    name: 'Kanvas Termal Kosong',
    originalName: 'Kertas Bon Kasir Kosong',
    tagline: 'Kertas termal sensitivitas tinggi untuk impian finansial yang belum ditulis.',
    price: 3400000,
    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQbU6PGSxZ7FsZe6JNFPEGs_qjS6GfZdPWyTpmx7BdCng&s',
    galleryImages: [
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQbU6PGSxZ7FsZe6JNFPEGs_qjS6GfZdPWyTpmx7BdCng&s',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQbU6PGSxZ7FsZe6JNFPEGs_qjS6GfZdPWyTpmx7BdCng&s',
    ],
    gradientColors: [const Color(0xFFDB2777), const Color(0xFF831843)],
    badge: 'ARTISAN',
    rating: 4.7,
    reviewCount: 132,
    description: 'Gulungan tanpa akhir dari kertas termal murni. Kanvas kosong untuk transaksi masa depan Anda, daftar belanjaan, atau puisi mendalam yang ditulis dengan tinta ungu pudar.',
  ),
  LuxuryProduct(
    id: '8',
    name: 'Mahkota Polimer Samudra',
    originalName: 'Tutup Botol Galon Biru',
    tagline: 'Komponen penyegel penghalang dari perairan biru dalam.',
    price: 950000,
    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQKBzUuLW8nDPDMpTY9JhnTW3arKvgp1znwjFra675-hg&s=10',
    galleryImages: [
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQKBzUuLW8nDPDMpTY9JhnTW3arKvgp1znwjFra675-hg&s=10',
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQKBzUuLW8nDPDMpTY9JhnTW3arKvgp1znwjFra675-hg&s=10',
    ],
    gradientColors: [const Color(0xFF0284C7), const Color(0xFF0C4A6E)],
    badge: 'KOLEKTOR',
    rating: 4.9,
    reviewCount: 289,
    description: 'Mahkota kejayaan infrastruktur hidrasi. Dibuat dari polimer tangguh dengan tonjolan penyegel berusuk yang melambangkan dominasi akuatik mutlak.',
  ),
];
