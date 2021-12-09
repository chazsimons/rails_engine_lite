<div id="top"></div>
[[Contributors][contributors-shield]][contributors-url]
[[Forks][forks-shield]][forks-url]
[[Stargazers][stars-shield]][stars-url]
[[LinkedIn][linkedin-shield]][linkedin-url]

<!-- PROJECT LOGO -->
<br />
[little rails engine](https://user-images.githubusercontent.com/85699215/145460175-60d4a051-6511-47b8-99a6-e3468a6a00c1.jpeg)


<h3 align="center">Rails Engine Lite</h3>

  <p align="center">
    <br />
    <br />
    <a href="https://github.com/chazsimons/rails_engine_lite/issues">Report Bug</a>
    ·
    <a href="https://github.com/chazsimons/rails_engine_lite/issues">Request Feature</a>
  </p>
</div>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>


<!-- ABOUT THE PROJECT -->
## About The Project

Rails Engine Lite is a mock e-commerce API. Explore multiple endpoints representing basic CRUD functionality on merchant and item information.

<p align="right">(<a href="#top">back to top</a>)</p>


### Built With

* [Ruby 2.7.2](https://ruby-lang.org/)
* [Rails 5.2.6](https://rubyonrails.org/)


<p align="right">(<a href="#top">back to top</a>)</p>


### Installation

1. Fork this repo(optional)
2. Clone the repo
   ```sh
   git clone https://github.com/chazsimons/rails_engine_lite.git
   ```
3. Run bundle install to get the necessary gems
   ```ruby
   bundle install
   ```
4. You're ready to go!
<p align="right">(<a href="#top">back to top</a>)</p>


<!-- USAGE EXAMPLES -->
## Usage

Find information on merchants and items using GET requests like:

```ruby
GET '/api/v1/merchants' #--> returns all merchants
GET '/api/v1/merchants/:id' #--> returns a single merchant
GET '/api/v1/items' #--> returns all items
```

You can create and delete entries as well using restful conventions.

Additionally, you can search for items and merchants using the following routes:

```ruby 
GET '/api/v1/merchants/find?name=' #--> returns a single merchant if found
GET '/api/v1/merchants/find_all?name=' #--> returns all merchants matching
GET '/api/v1/items/find?name=' #--> returns a single item if found
GET '/api/v1/items/find_all?name=' #--> returns all items matching
```

Items can also be searched for using min_price and max_price, or a range between the two.

<p align="right">(<a href="#top">back to top</a>)</p>


<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#top">back to top</a>)</p>


## Contact

Reach me by email at: chaz.simons@gmail.com

Project Link: [https://github.com/chazsimons/rails_engine_lite](https://github.com/chazsimons/rails_engine_lite)

<p align="right">(<a href="#top">back to top</a>)</p>


<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/chazsimons/rails_engine_lite.svg?style=for-the-badge
[contributors-url]: https://github.com/chazsimons/rails_engine_lite/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/chazsimons/rails_engine_lite.svg?style=for-the-badge
[forks-url]: https://github.com/chazsimons/rails_engine_lite/network/members
[stars-shield]: https://img.shields.io/github/stars/chazsimons/rails_engine_lite.svg?style=for-the-badge
[stars-url]: https://github.com/chazsimons/rails_engine_lite/stargazers
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/chaz-simons
