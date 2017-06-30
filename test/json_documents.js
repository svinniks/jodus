suite("JSON path parser tests", function() {

    test("Invalid start of the path", function() {
    
        expect(function() {
        
            var result = database.call("json_documents.parse_path", {
                p_path_string: "123"
            });
        
        }).to.throw(/JPTH-00001/);
    
    });

    test("Invalid start of the path with spaces", function() {
    
        expect(function() {
        
            var result = database.call("json_documents.parse_path", {
                p_path_string: "   123"
            });
        
        }).to.throw(/JPTH-00001/);
    
    });
    
    test("Invalid start of the property", function() {
    
        expect(function() {
        
            var result = database.call("json_documents.parse_path", {
                p_path_string: "hello.123"
            });
        
        }).to.throw(/JPTH-00001/);
    
    });

    test("Invalid start of the property with spaces", function() {
    
        expect(function() {
        
            var result = database.call("json_documents.parse_path", {
                p_path_string: "  hello  .  123"
            });
        
        }).to.throw(/JPTH-00001/);
    
    });

    test("Invalid character in simple name", function() {
    
        expect(function() {
        
            var result = database.call("json_documents.parse_path", {
                p_path_string: "hello-123"
            });
        
        }).to.throw(/JPTH-00001/);
    
    });

    test("Invalid start of ID", function() {
    
        expect(function() {
        
            var result = database.call("json_documents.parse_path", {
                p_path_string: "#a"
            });
        
        }).to.throw(/JPTH-00001/);
    
    });

    test("Invalid character in ID", function() {
    
        expect(function() {
        
            var result = database.call("json_documents.parse_path", {
                p_path_string: "#123a"
            });
        
        }).to.throw(/JPTH-00001/);
    
    });

    test(". or [ missing", function() {
    
        expect(function() {
        
            var result = database.call("json_documents.parse_path", {
                p_path_string: "abc abc"
            });
        
        }).to.throw(/JPTH-00001/);
    
    });

    test("Invalid start of array element", function() {
    
        expect(function() {
        
            var result = database.call("json_documents.parse_path", {
                p_path_string: "abc[cda]"
            });
        
        }).to.throw(/JPTH-00001/);
    
    });

    test("Invalid start of array element with spaces", function() {
    
        expect(function() {
        
            var result = database.call("json_documents.parse_path", {
                p_path_string: "  abc  [  cba  ]  "
            });
        
        }).to.throw(/JPTH-00001/);
    
    });

    test("Invalid character in array element", function() {
    
        expect(function() {
        
            var result = database.call("json_documents.parse_path", {
                p_path_string: "abc[123a]"
            });
        
        }).to.throw(/JPTH-00001/);
    
    });

    test("] missing", function() {
    
        expect(function() {
        
            var result = database.call("json_documents.parse_path", {
                p_path_string: "abc[123.cba"
            });
        
        }).to.throw(/JPTH-00001/);
    
    });

    test("Trailing ] missing", function() {
    
        expect(function() {
        
            var result = database.call("json_documents.parse_path", {
                p_path_string: "abc[123"
            });
        
        }).to.throw(/JPTH-00002/);
    
    });

    test("Name closing quote missing", function() {
    
        expect(function() {
        
            var result = database.call("json_documents.parse_path", {
                p_path_string: "\"abc" 
            });
        
        }).to.throw(/JPTH-00002/);
    
    });

    test("Array element closing quote missing", function() {
    
        expect(function() {
        
            var result = database.call("json_documents.parse_path", {
                p_path_string: 'hello["world'
            });
        
        }).to.throw(/JPTH-00002/);
    
    });

    test("Dot in the end", function() {
    
        expect(function() {
        
            var result = database.call("json_documents.parse_path", {
                p_path_string: 'hello.world.'
            });
        
        }).to.throw(/JPTH-00002/);
    
    });

    test("Dot in the end with spaces", function() {
    
        expect(function() {
        
            var result = database.call("json_documents.parse_path", {
                p_path_string: '  hello  .  world  .  '
            });
        
        }).to.throw(/JPTH-00002/);
    
    });

    test("Empty path", function() {

        var result = database.call("json_documents.parse_path", {
            p_path_string: null
        });

        expect(result).to.eql([]);

    });

    test("Empty path (spaces only)", function() {

        var result = database.call("json_documents.parse_path", {
            p_path_string: "   "
        });

        expect(result).to.eql([]);

    });

    test("Root only", function() {

        var result = database.call("json_documents.parse_path", {
            p_path_string: "$"
        });

        expect(result).to.eql([
            {
                type: 1,
                value: null
            }
        ]);

    });

    test("Root only with spaces", function() {

        var result = database.call("json_documents.parse_path", {
            p_path_string: "  $    "
        });

        expect(result).to.eql([
            {
                type: 1,
                value: null
            }
        ]);

    });

    test("Single simple name", function() {

        var result = database.call("json_documents.parse_path", {
            p_path_string: "hello"
        });

        expect(result).to.eql([
            {
                type: 3,
                value: "hello"
            }
        ]);

    });

    test("Single simple name with spaces", function() {

        var result = database.call("json_documents.parse_path", {
            p_path_string: "   hello   "
        });

        expect(result).to.eql([
            {
                type: 3,
                value: "hello"
            }
        ]);

    });

    test("Single quoted name", function() {

        var result = database.call("json_documents.parse_path", {
            p_path_string: '" 89 "'
        });

        expect(result).to.eql([
            {
                type: 3,
                value: " 89 "
            }
        ]);

    });

    test("Single quoted name with spaces", function() {

        var result = database.call("json_documents.parse_path", {
            p_path_string: '   " 89 "   '
        });

        expect(result).to.eql([
            {
                type: 3,
                value: " 89 "
            }
        ]);

    });

    test("Single quoted name with escaped quote", function() {

        var result = database.call("json_documents.parse_path", {
            p_path_string: '" 89\\" "'
        });

        expect(result).to.eql([
            {
                type: 3,
                value: " 89\" "
            }
        ]);

    });

    test("Single ID", function() {

        var result = database.call("json_documents.parse_path", {
            p_path_string: '#12345'
        });

        expect(result).to.eql([
            {
                type: 2,
                value: "12345"
            }
        ]);

    });

    test("Single ID with spaces", function() {

        var result = database.call("json_documents.parse_path", {
            p_path_string: '   #12345   '
        });

        expect(result).to.eql([
            {
                type: 2,
                value: "12345"
            }
        ]);

    });

    test("Single digit array element of root", function() {

        var result = database.call("json_documents.parse_path", {
            p_path_string: '$[1]'
        });

        expect(result).to.eql([
            {
                type: 1,
                value: null
            },
            {
                type: 3,
                value: "1"
            }
        ]);

    });

    test("Single digit array element of root with spaces", function() {

        var result = database.call("json_documents.parse_path", {
            p_path_string: '  $  [  1  ]  '
        });

        expect(result).to.eql([
            {
                type: 1,
                value: null
            },
            {
                type: 3,
                value: "1"
            }
        ]);

    });

    test("Multi-digit array element of root", function() {

        var result = database.call("json_documents.parse_path", {
            p_path_string: '$[12345]'
        });

        expect(result).to.eql([
            {
                type: 1,
                value: null
            },
            {
                type: 3,
                value: "12345"
            }
        ]);

    });

    test("Multi-digit array element of root with spaces", function() {

        var result = database.call("json_documents.parse_path", {
            p_path_string: '  $  [  12345  ]  '
        });

        expect(result).to.eql([
            {
                type: 1,
                value: null
            },
            {
                type: 3,
                value: "12345"
            }
        ]);

    });

    test("Quoted array element of root", function() {

        var result = database.call("json_documents.parse_path", {
            p_path_string: '$["hello"]'
        });

        expect(result).to.eql([
            {
                type: 1,
                value: null
            },
            {
                type: 3,
                value: "hello"
            }
        ]);

    });

    test("Quoted array element of root with spaces", function() {

        var result = database.call("json_documents.parse_path", {
            p_path_string: '  $  [  "hello"  ]  '
        });

        expect(result).to.eql([
            {
                type: 1,
                value: null
            },
            {
                type: 3,
                value: "hello"
            }
        ]);

    });

    test("Array element of simple name", function() {

        var result = database.call("json_documents.parse_path", {
            p_path_string: 'hello[123]'
        });

        expect(result).to.eql([
            {
                type: 3,
                value: "hello"
            },
            {
                type: 3,
                value: "123"
            }
        ]);

    });

    test("Array element of simple name with spaces", function() {

        var result = database.call("json_documents.parse_path", {
            p_path_string: '  hello  [  123  ]  '
        });

        expect(result).to.eql([
            {
                type: 3,
                value: "hello"
            },
            {
                type: 3,
                value: "123"
            }
        ]);

    });

    test("Array element of quoted name", function() {

        var result = database.call("json_documents.parse_path", {
            p_path_string: '"hello"[123]'
        });

        expect(result).to.eql([
            {
                type: 3,
                value: "hello"
            },
            {
                type: 3,
                value: "123"
            }
        ]);

    });

    test("Array element of quoted name with spaces", function() {

        var result = database.call("json_documents.parse_path", {
            p_path_string: '  "hello"  [  123  ]  '
        });

        expect(result).to.eql([
            {
                type: 3,
                value: "hello"
            },
            {
                type: 3,
                value: "123"
            }
        ]);

    });

    test("Array element of ID", function() {

        var result = database.call("json_documents.parse_path", {
            p_path_string: '#123[456]'
        });

        expect(result).to.eql([
            {
                type: 2,
                value: "123"
            },
            {
                type: 3,
                value: "456"
            }
        ]);

    });

    test("Array element of ID with spaces", function() {

        var result = database.call("json_documents.parse_path", {
            p_path_string: '  #123  [  456  ]  '
        });

        expect(result).to.eql([
            {
                type: 2,
                value: "123"
            },
            {
                type: 3,
                value: "456"
            }
        ]);

    });

    test("Multi-dimensional array access", function() {

        var result = database.call("json_documents.parse_path", {
            p_path_string: 'array[123]["321"]'
        });

        expect(result).to.eql([
            {
                type: 3,
                value: "array"
            },
            {
                type: 3,
                value: "123"
            },
            {
                type: 3,
                value: "321"
            }
        ]);

    });

    test("Multi-dimensional array access with spaces", function() {

        var result = database.call("json_documents.parse_path", {
            p_path_string: ' array [123] ["321"] '
        });

        expect(result).to.eql([
            {
                type: 3,
                value: "array"
            },
            {
                type: 3,
                value: "123"
            },
            {
                type: 3,
                value: "321"
            }
        ]);

    });

    test("Multiple mixed elements", function() {

        var result = database.call("json_documents.parse_path", {
            p_path_string: 'hello.world.#12345.#54321."aaa"."bbb"[1]'
        });

        expect(result).to.eql([
            {
                type: 3,
                value: "hello"
            },
            {
                type: 3,
                value: "world"
            },
            {
                type: 2,
                value: "12345"
            },
            {
                type: 2,
                value: "54321"
            },
            {
                type: 3,
                value: "aaa"
            },
            {
                type: 3,
                value: "bbb"
            },
            {
                type: 3,
                value: "1"
            }
        ]);

    });

    test("Multiple mixed elements with spaces", function() {

        var result = database.call("json_documents.parse_path", {
            p_path_string: '  hello  .  world  .  #12345  .  #54321  .  "aaa"  .  "bbb"  '
        });

        expect(result).to.eql([
            {
                type: 3,
                value: "hello"
            },
            {
                type: 3,
                value: "world"
            },
            {
                type: 2,
                value: "12345"
            },
            {
                type: 2,
                value: "54321"
            },
            {
                type: 3,
                value: "aaa"
            },
            {
                type: 3,
                value: "bbb"
            }
        ]);

    });

    test("Multiple mixed elements starting with root", function() {

        var result = database.call("json_documents.parse_path", {
            p_path_string: '$.hello.world.#12345.#54321."aaa"."bbb"'
        });

        expect(result).to.eql([
            {
                type: 1,
                value: null
            },
            {
                type: 3,
                value: "hello"
            },
            {
                type: 3,
                value: "world"
            },
            {
                type: 2,
                value: "12345"
            },
            {
                type: 2,
                value: "54321"
            },
            {
                type: 3,
                value: "aaa"
            },
            {
                type: 3,
                value: "bbb"
            }
        ]);

    });

    test("Multiple mixed elements starting with root, with spaces", function() {

        var result = database.call("json_documents.parse_path", {
            p_path_string: '  $  .  hello . world.#12345.#54321."aaa"."bbb"'
        });

        expect(result).to.eql([
            {
                type: 1,
                value: null
            },
            {
                type: 3,
                value: "hello"
            },
            {
                type: 3,
                value: "world"
            },
            {
                type: 2,
                value: "12345"
            },
            {
                type: 2,
                value: "54321"
            },
            {
                type: 3,
                value: "aaa"
            },
            {
                type: 3,
                value: "bbb"
            }
        ]);

    });

});