-- phpMyAdmin SQL Dump
-- version 4.3.4
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Feb 13, 2015 at 02:07 AM
-- Server version: 5.6.22
-- PHP Version: 5.5.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `stone`
--

-- --------------------------------------------------------

--
-- Table structure for table `friend`
--

CREATE TABLE IF NOT EXISTS `friend` (
  `uid` varchar(32) NOT NULL,
  `fid` varchar(32) NOT NULL,
  `status` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `friend`
--

INSERT INTO `friend` (`uid`, `fid`, `status`) VALUES
('1', '2', 1),
('1', '3', 1),
('1', '4', 1),
('1', '5', 1),
('2', '1', 1),
('2', '3', 1);

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE IF NOT EXISTS `user` (
  `uid` varchar(32) NOT NULL,
  `psw` varchar(32) NOT NULL,
  `token` varchar(100) NOT NULL,
  `portrait` varchar(300) NOT NULL,
  `stoken` varchar(100) DEFAULT NULL,
  `name` varchar(32) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`uid`, `psw`, `token`, `portrait`, `stoken`, `name`) VALUES
('1', '1', '67de47b3bb13cc238e334443ecbc4d6b', 'http://rongcloud-web.qiniudn.com/docs_demo_rongcloud_logo.png', 'i77eSHIVtEnA7Q8j1fygl1vWYEjLmCtgXBq6nWAvUzIrE71NY0z/DJJl9N2zDiHvx98IlAF+HhwYLngcMzrprw==', 'shayu'),
('2', '2', '138ca89ae2a120984554a895bea78d52', 'http://rongcloud-web.qiniudn.com/docs_demo_rongcloud_logo.png', 'n0ojpf/4z6Kc8xcAp3NrPVvWYEjLmCtgXBq6nWAvUzIrE71NY0z/DG36m9b8uMkdXCxpsbq9TocYLngcMzrprw==', 'shayu'),
('3', '3', 'e5fb56f82e1ddc9a8a3d3cdf6f8e3a71', 'http://rongcloud-web.qiniudn.com/docs_demo_rongcloud_logo.png', 'zsKuqDshcH/fRxsqLGnIFDE9ifuTwgL3K/9j7WQx1woInBxzZ9mm390KmqTsqLh0yolRoS4PWZk=', 'shayu'),
('4', '4', '55cfee9eb13b0bc51a9a2d01d8eff902', 'http://rongcloud-web.qiniudn.com/docs_demo_rongcloud_logo.png', 'PHUOtO6PjhiF9BwaFqudLTE9ifuTwgL3K/9j7WQx1woInBxzZ9mm32UZy/+3GHx5PjUyXZECLVw=', 'shayu'),
('5', '5', 'bd912903c8e641175d03e63378f73580', 'https://git.oschina.net/wfxlong/default_photo/raw/master/2.jpeg', 'JkuuQbAT46mj0Ejbiy/Zz+ZeuUu3+fcfwJF3TQOauKdT6ECOdzgnJpELVIda2Ss3X2bWHVv+4l0pctzphgwSDw==', '俊宇'),
('7', '7', '36255015fc087af7fc468dbcff08705b', 'https://git.oschina.net/wfxlong/default_photo/raw/master/3.png', 'gzaung4vVg+cfYpCNA1z6lvWYEjLmCtgXBq6nWAvUzIrE71NY0z/DHuxs0IJ+E88hssFCSnn1aEYLngcMzrprw==', '逗比');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
