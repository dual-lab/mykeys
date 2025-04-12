return require("telescope").register_extension {
    setup = function (ext_config, config)

    end,
    exports = {
        mykeys = require("telescope._extensions.keys_mapped")
    }
}
