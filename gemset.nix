{
  barby = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04z2v925ph29cz7mg8amr7wyjsgrfzgw0abrv4sn2n8f6867rg4d";
      type = "gem";
    };
    version = "0.7.0";
  };
  builder = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0pw3r2lyagsxkm71bf44v5b74f7l9r7di22brbyji9fwz791hya9";
      type = "gem";
    };
    version = "3.3.0";
  };
  chunky_png = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1znw5x86hmm9vfhidwdsijz8m38pqgmv98l9ryilvky0aldv7mc9";
      type = "gem";
    };
    version = "1.4.0";
  };
  dmtx = {
    dependencies = ["builder" "chunky_png"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "16wz0dnl5x20v80s4mh732xqnwkj0mjhcnwki85d79f8m0m8va5r";
      type = "gem";
    };
    version = "1.0.1";
  };
  logger = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "00q2zznygpbls8asz5knjvvj2brr3ghmqxgr83xnrdj4rk3xwvhr";
      type = "gem";
    };
    version = "1.7.0";
  };
  ostruct = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04nrir9wdpc4izqwqbysxyly8y7hsfr4fsv69rw91lfi9d5fv8lm";
      type = "gem";
    };
    version = "0.6.3";
  };
  rack = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "137r9zqwh0dan6s0fw91wk6iip9alh44bqgbhn80sxk0h5kp7150";
      type = "gem";
    };
    version = "3.0.11";
  };
  rack-unreloader = {
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0fi6qxicls6fax8qm7bx7yz6xkjwyq3agg1n32h23jnqrvr9r1qq";
      type = "gem";
    };
    version = "2.1.0";
  };
  rackup = {
    dependencies = ["rack" "webrick"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0kbcka30g681cqasw47pq93fxjscq7yvs5zf8lp3740rb158ijvf";
      type = "gem";
    };
    version = "2.1.0";
  };
  rake = {
    groups = ["development"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "17850wcwkgi30p7yqh60960ypn7yibacjjha0av78zaxwvd3ijs6";
      type = "gem";
    };
    version = "13.2.1";
  };
  roda = {
    dependencies = ["rack"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1jn8fsl0d5ib93pzq9gyqmsb40ggqvdq9abm0sg1px1x5qf9b45z";
      type = "gem";
    };
    version = "3.80.0";
  };
  rqrcode = {
    dependencies = ["chunky_png" "rqrcode_core"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1hggzz8i1l62pkkiybhiqv6ypxw7q844sddrrbbfczjcnj5sivi3";
      type = "gem";
    };
    version = "2.2.0";
  };
  rqrcode_core = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "06ld6386hbdhy5h0k09axmgn424kavpc8f27k1vjhknjhbf8jjfg";
      type = "gem";
    };
    version = "1.2.0";
  };
  webrick = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "13qm7s0gr2pmfcl7dxrmq38asaza4w0i2n9my4yzs499j731wh8r";
      type = "gem";
    };
    version = "1.8.1";
  };
}
