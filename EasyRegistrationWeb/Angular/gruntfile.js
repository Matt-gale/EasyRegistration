/// <binding BeforeBuild="devBuild" />
var outputWWWRoot = "../API/wwwroot";

module.exports = function (grunt) {

    grunt.initConfig({
        // Copy all JS files from external libraries and required NPM packages to wwwroot/js
        copy: {
            fonts: {
                files: [
                    {
                        expand: true,
                        dest: outputWWWRoot + "/app/fonts",
                        nonull: true,
                        flatten: true,
                        src: [
                            "node_modules/font-awesome/fonts/*"
                        ]
                    },
                    {
                        expand: true,
                        dest: outputWWWRoot + "/app/css",
                        nonull: true,
                        flatten: true,
                        src: [
                            "node_modules/font-awesome/css/font-awesome.min.css"
                        ]
                    }
                ]
            },
            libsjit: {
                options: {
                    process: function (content, srcpath) {
                        var re = /^\/\/#\ssourceMappingURL(.+)$/gm;
                        return content.replace(re, "");
                    }
                },
                files: [
                    {
                        expand: true,
                        dest: outputWWWRoot + "/node_libs",
                        nonull: true,
                        flatten: true,
                        src: [
                            "node_modules/core-js/client/shim.min.js",
                            "node_modules/zone.js/dist/zone.min.js",
                            "node_modules/reflect-metadata/Reflect.js",
                            "node_modules/systemjs/dist/system.js",
                            "src/systemjs.config.js"
                        ]
                    }
                ]
            },
            htmljit: {
                files: [
                    {
                        expand: true,
                        dest: outputWWWRoot + "/app/",
                        nonull: true,
                        src: [
                            "src/app/**/*.html"
                        ],
                        rename: function (dest, src) {
                            return dest + src.replace('src/app/', '');
                        }
                    }
                ]
            },
            indexjit: {
                files: [
                    {
                        expand: true,
                        dest: outputWWWRoot + "/",
                        nonull: true,
                        flatten: true,
                        src: [
                            "src/index-jit.html"
                        ],
                        rename: function (dest, src) {
                            return dest + src.replace('-jit', '');
                        }
                    }
                ]
            },
            indexaot: {
                files: [
                    {
                        expand: true,
                        dest: outputWWWRoot + "/",
                        nonull: true,
                        flatten: true,
                        src: [
                            "src/index-aot.html"
                        ],
                        rename: function (dest, src) {
                            return dest + src.replace('-aot', '');
                        }
                    }
                ]
            }
        },
        less: {
            build: {
                options: {
                    paths: [outputWWWRoot + "/app/css"],
                    relativeUrls: true,
                    strictUnits: true,
                    strictMath: true,
                    strictImports: true
                },
                files: [
                    {
                        expand: true,
                        flatten: true,
                        dest: outputWWWRoot + "/app",
                        src: "src/app/less/*.less",
                        ext: ".css"
                    }
                ]
            }
        },
        shell: {
            options: {
                stdout: false,
                stderr: false,
                execOptions: {
                    maxBuffer: Infinity
                }
            },
            ngc: {
                command: [
                    "ngc",
                    "ngc"
                ].join(" && ")
            }
        },

        clean: {
            build: {
                src: [
                    outputWWWRoot + "/**/*.*"
                ],
                options: {
                    force: true
                }
            }
        }

    });
    
    grunt.loadNpmTasks("grunt-contrib-clean");
    grunt.loadNpmTasks("grunt-contrib-copy");
    grunt.loadNpmTasks("grunt-contrib-less");
    grunt.loadNpmTasks("grunt-contrib-watch");
    grunt.loadNpmTasks("grunt-shell");

    grunt.registerTask("devBuild", [
        "clean:build",
        "copy:libsjit",
        "copy:fonts",
        "copy:htmljit",
        "less",
        "shell:ngc",
        "copy:indexjit",
    ]);
};