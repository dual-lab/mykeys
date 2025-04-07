<div id="top"></div>


[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![MIT License][license-shield]][license-url]
[![GitHub release][version-shield]][version-url]
[![lua]](http://www.lua.org)
[![Neovim](https:)](https://neovim.io)


<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/dual-lab/mykeys">
     <img src="key.png" alt="Logo" width="80" height="80">
  </a>
  <h6>
    <small>
      <a href="https://www.flaticon.com/free-icons/keys" title="keys icons">Keys icons created by Smashicons - Flaticon</a>
    </small>
  </h6>

<h3 align="center">mykeys</h3>

  <p align="center">
    Neovim plugin
    <br />
    <a href="https://github.com/dual-lab/mykeys"><strong>Explore the docs »</strong></a>
    <br />
    <br />
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
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

<!-- [![Product Name Screen Shot][product-screenshot]](https://example.com) -->

"mykeys" is a neovim plugin written in lua, that try show all your mappe keys.

>[!IMPORTANT]
> I don't know what i'm doing

<p align="right">(<a href="#top">back to top</a>)</p>



### Built With

* [Lua](https://www.lua.org/)


<p align="right">(<a href="#top">back to top</a>)</p>


<!-- GETTING STARTED -->
## Getting Started

TODO

### Prerequisites

TODO

### Installation

The plugin can be installed with a Neovim package manager.

lazy.nvim

```lua
return {
    "dual-lab/mykeys",

    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    name = "mykeys",
    config = function()
        local mykeys = require('mykeys');

        mykeys.setup()

        vim.keymap.set("n", "<leader>mk"
        , function() mykeys.toggle() end, { desc = "mykeys: toggle" })
    end
}
```

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- USAGE EXAMPLES -->
## Usage

Set a keymap in lua

```lua
vim.keymap.set("n", "<leader>mk"
        , function() mykeys.toggle() end, { desc = "mykeys: toggle" })
```

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- ROADMAP -->
## Roadmap

- [x] Create a simple popup that show insert,normal and visual mode mapped keys
- [ ] Add more config option
- [ ] Add a prompt buffer + popup in order to search inside the list
- [ ] Create a telescope extension
- [ ] Try to execute the associate function on selection

<p align="right">(<a href="#top">back to top</a>)</p>


<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE` for more information.

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- CONTACT -->
## Contact

Dual-lab team - dual-lab@yandex.com

Project Link: [https://github.com/dual-lab/mykeys](https://github.com/dual-lab/mykeys)

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- ACKNOWLEDGMENTS -->
## Acknowledgments


<p align="right">(<a href="#top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[forks-shield]: https://img.shields.io/github/forks/dual-lab/mykeys.svg?style=for-the-badge
[forks-url]: https://github.com/dual-lab/mykeys/network/members
[stars-shield]: https://img.shields.io/github/stars/dual-lab/mykeys.svg?style=for-the-badge
[stars-url]: https://github.com/dual-lab/mykeys/stargazers
[license-shield]: https://img.shields.io/github/license/dual-lab/mykeys.svg?style=for-the-badge
[license-url]: https://github.com/dual-lab/mykeys/blob/master/LICENSE
[product-screenshot]: images/screenshot.png
[version-shield]: https://img.shields.io/github/v/release/dual-lab/mykeys?include_prereleases&sort=semver&style=for-the-badge
[version-url]: https://github.com/dual-lab/mykeys/releases
[lua]:https://img.shields.io/badge/Lua-blue.svg?style=for-the-badge&logo=lua
[neovim]: https://img.shields.io/badge/Neovim%200.5+-green.svg?style=for-the-badge&logo=neovim
