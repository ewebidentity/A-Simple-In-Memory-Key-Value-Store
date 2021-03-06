-module(im_store_app).

-behavior(e2_application).

-export([init/0]).

-define(DEFAULT_DB_FILE, "data.db").

-define(DEFAULT_PORT, 1234).

-define(DEFAULT_PORT2, 1156).

-define(DEFAULT_PORT3, 4000).


%%%===================================================================
%%% e2_application callbacks
%%%===================================================================

	init() ->
		{ok, [{im_store_data, start_link, [db_file()]},
			{im_store_client_handler_sup, [supervisor]},
			{im_store_server, start_link, [server_port()]},
			{im_store_http_server, start_link, [server_port2(), [], null]},
			{im_store_udp_server, init, [server_port3()]},
			{im_store_udp_client_sup, start_link, [supervisor]}
		]}.

%%%===================================================================
%%% Internal Functions
%%%===================================================================

	db_file() ->
		app_config(db_file, ?DEFAULT_DB_FILE).

	server_port() ->
		app_config(server_port, ?DEFAULT_PORT).
		
	server_port2() ->
		app_config(server_port2, ?DEFAULT_PORT2).
		
	server_port3() ->
		app_config(server_port3, ?DEFAULT_PORT3).
		
	app_config(Name, Default) ->
    handle_app_env(application:get_env(Name), Default).

	handle_app_env({ok, Value}, _Default) -> Value;
	handle_app_env(undefined, Default) -> Default.