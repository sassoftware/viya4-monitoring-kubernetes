# CloudWatch SAS Viya Metrics

## By Dimensions
lists the metrics associated with each set of dimensions
<details>
  <summary>Click to expand</summary>
<b>ClusterName,cas_node,cas_node_type,cas_server,job,namespace,pod,type</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| cas_node_cpu_time_seconds | sas-cas |
| cas_node_mem_free_bytes | sas-cas |
| cas_node_mem_size_bytes | sas-cas |

<b>ClusterName,cas_node,cas_node_type,cas_server,job,namespace,pod</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| cas_node_fifteen_minute_cpu_load_avg | sas-cas |
| cas_node_five_minute_cpu_load_avg | sas-cas |
| cas_node_free_files | sas-cas |
| cas_node_inodes_free | sas-cas |
| cas_node_inodes_used | sas-cas |
| cas_node_max_open_files | sas-cas |
| cas_node_one_minute_cpu_load_avg | sas-cas |
| cas_node_open_files | sas-cas |

<b>ClusterName,cas_node,cas_node_type,cas_server,connected,job,namespace,pod,uuid</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| cas_nodes | sas-cas |

<b>ClusterName,cas_server,job,namespace,pod</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| cas_grid_idle_seconds | sas-cas |
| cas_grid_sessions_created_total | sas-cas |
| cas_grid_sessions_current | sas-cas |
| cas_grid_sessions_max | sas-cas |
| cas_grid_start_time_seconds | sas-cas |
| cas_grid_uptime_seconds_total | sas-cas |

<b>ClusterName,cas_server,job,namespace,pod,state</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| cas_grid_state | sas-cas |

<b>ClusterName,job,method,namespace,node,pod,quantile,sas_service_base,service,status</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| arke_request_elapsed | sas-go |

<b>ClusterName,job,namespace,node,pod,reason,sas_service_base,schema,service</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| sas_db_closed_total | sas-go |

<b>ClusterName,job,namespace,node,pod,sas_service_base,service,state</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| sas_db_connections_max | sas-go |
| sas_db_pool_connections | sas-go |

<b>ClusterName,job,namespace,node,pod,sas_service_base,schema,service</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| sas_db_wait_seconds | sas-go |
| sas_db_wait_total | sas-go |

<b>ClusterName,job,namespace,node,pod,sas_service_base,service</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| arke_client_active_messages | sas-go |
| arke_client_consumed_total | sas-go |
| arke_client_produced_total | sas-go |
| arke_client_streams | sas-go |
| arke_recvmsg_total | sas-go |
| arke_request_elapsed_count | sas-go |
| arke_request_elapsed_sum | sas-go |
| arke_request_total | sas-go |
| arke_sendmsg_total | sas-go |
| go_gc_duration_seconds_count | sas-go |
| go_gc_duration_seconds_sum | sas-go |
| go_goroutines | sas-go |
| go_memstats_alloc_bytes | sas-go |
| go_memstats_alloc_bytes_total | sas-go |
| go_memstats_buck_hash_sys_bytes | sas-go |
| go_memstats_frees_total | sas-go |
| go_memstats_gc_cpu_fraction | sas-go |
| go_memstats_gc_sys_bytes | sas-go |
| go_memstats_heap_alloc_bytes | sas-go |
| go_memstats_heap_idle_bytes | sas-go |
| go_memstats_heap_inuse_bytes | sas-go |
| go_memstats_heap_objects | sas-go |
| go_memstats_heap_released_bytes | sas-go |
| go_memstats_heap_sys_bytes | sas-go |
| go_memstats_last_gc_time_seconds | sas-go |
| go_memstats_lookups_total | sas-go |
| go_memstats_mallocs_total | sas-go |
| go_memstats_mcache_inuse_bytes | sas-go |
| go_memstats_mcache_sys_bytes | sas-go |
| go_memstats_mspan_inuse_bytes | sas-go |
| go_memstats_mspan_sys_bytes | sas-go |
| go_memstats_next_gc_bytes | sas-go |
| go_memstats_other_sys_bytes | sas-go |
| go_memstats_stack_inuse_bytes | sas-go |
| go_memstats_stack_sys_bytes | sas-go |
| go_memstats_sys_bytes | sas-go |
| go_threads | sas-go |
| process_cpu_seconds_total | sas-go |
| process_max_fds | sas-go |
| process_open_fds | sas-go |
| process_resident_memory_bytes | sas-go |
| process_start_time_seconds | sas-go |
| process_virtual_memory_bytes | sas-go |
| process_virtual_memory_max_bytes | sas-go |
| runtime_alloc_bytes | sas-go |
| runtime_free_count | sas-go |
| runtime_gc_pause_ns_count | sas-go |
| runtime_gc_pause_ns_sum | sas-go |
| runtime_heap_objects | sas-go |
| runtime_malloc_count | sas-go |
| runtime_num_goroutines | sas-go |
| runtime_sys_bytes | sas-go |
| runtime_total_gc_pause_ns | sas-go |
| runtime_total_gc_runs | sas-go |
| sas_db_wait_seconds | sas-go |
| sas_db_wait_total | sas-go |
| sas_maps_esri_query_duration_seconds_count | sas-go |
| sas_maps_esri_query_duration_seconds_sum | sas-go |
| sas_maps_report_polling_attempts_total | sas-go |
| sas_maps_report_query_duration_seconds_count | sas-go |
| sas_maps_report_query_duration_seconds_sum | sas-go |

<b>ClusterName,job,namespace,node,pod,reason,sas_service_base,service</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| sas_db_closed_total | sas-go |

<b>ClientIdentitifer,ClusterName,job,namespace,node,pod,sas_service_base,service</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| arke_client_active_messages | sas-go |
| arke_client_consumed_total | sas-go |
| arke_client_produced_total | sas-go |
| arke_client_streams | sas-go |

<b>ClusterName,job,namespace,node,pod,quantile,sas_service_base,service</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| go_gc_duration_seconds | sas-go |
| runtime_gc_pause_ns | sas-go |

<b>ClusterName,job,level,namespace,node,pod,sas_service_base,service</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| log_events_total | sas-go |

<b>ClusterName,job,namespace,node,pod,sas_service_base,schema,service,state</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| sas_db_connections_max | sas-go |
| sas_db_pool_connections | sas-go |

<b>ClusterName,job,method,namespace,node,pod,sas_service_base,service,status</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| arke_recvmsg_total | sas-go |
| arke_request_elapsed_count | sas-go |
| arke_request_elapsed_sum | sas-go |
| arke_request_total | sas-go |
| arke_sendmsg_total | sas-go |

<b>ClusterName,id,job,namespace,node,pod,sas_service_base</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| jvm_buffer_count_buffers | sas-java |
| jvm_buffer_memory_used_bytes | sas-java |
| jvm_buffer_total_capacity_bytes | sas-java |

<b>ClusterName,job,listener_id,namespace,node,pod,queue,result,sas_service_base</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| spring_rabbitmq_listener_seconds_count | sas-java |
| spring_rabbitmq_listener_seconds_max | sas-java |
| spring_rabbitmq_listener_seconds_sum | sas-java |

<b>ClusterName,job,method,namespace,node,outcome,pod,sas_service_base,status,uri</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| http_server_requests_seconds_count | sas-java |
| http_server_requests_seconds_max | sas-java |
| http_server_requests_seconds_sum | sas-java |

<b>ClusterName,job,name,namespace,node,pod,sas_service_base</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| jdbc_connections_active | sas-java |
| jdbc_connections_idle | sas-java |
| jdbc_connections_max | sas-java |
| jdbc_connections_min | sas-java |
| rabbitmq_acknowledged_published_total | sas-java |
| rabbitmq_acknowledged_total | sas-java |
| rabbitmq_channels | sas-java |
| rabbitmq_connections | sas-java |
| rabbitmq_consumed_total | sas-java |
| rabbitmq_failed_to_publish_total | sas-java |
| rabbitmq_not_acknowledged_published_total | sas-java |
| rabbitmq_published_total | sas-java |
| rabbitmq_rejected_total | sas-java |
| rabbitmq_unrouted_published_total | sas-java |
| tomcat_global_error_total | sas-java |
| tomcat_global_received_bytes_total | sas-java |
| tomcat_global_request_max_seconds | sas-java |
| tomcat_global_request_seconds_count | sas-java |
| tomcat_global_request_seconds_sum | sas-java |
| tomcat_global_sent_bytes_total | sas-java |
| tomcat_servlet_error_total | sas-java |
| tomcat_servlet_request_max_seconds | sas-java |
| tomcat_servlet_request_seconds_count | sas-java |
| tomcat_servlet_request_seconds_sum | sas-java |
| tomcat_threads_busy_threads | sas-java |
| tomcat_threads_config_max_threads | sas-java |
| tomcat_threads_current_threads | sas-java |

<b>ClusterName,job,namespace,node,pod,sas_service_base</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| jvm_classes_loaded_classes | sas-java |
| jvm_classes_unloaded_classes_total | sas-java |
| jvm_gc_live_data_size_bytes | sas-java |
| jvm_gc_max_data_size_bytes | sas-java |
| jvm_gc_memory_allocated_bytes_total | sas-java |
| jvm_gc_memory_promoted_bytes_total | sas-java |
| jvm_threads_daemon_threads | sas-java |
| jvm_threads_live_threads | sas-java |
| jvm_threads_peak_threads | sas-java |
| process_cpu_usage | sas-java |
| process_files_max_files | sas-java |
| process_files_open_files | sas-java |
| process_start_time_seconds | sas-java |
| process_uptime_seconds | sas-java |
| spring_integration_channels | sas-java |
| spring_integration_handlers | sas-java |
| spring_integration_sources | sas-java |
| system_cpu_count | sas-java |
| system_cpu_usage | sas-java |
| system_load_average_1m | sas-java |
| tomcat_cache_access_total | sas-java |
| tomcat_cache_hit_total | sas-java |
| tomcat_sessions_active_current_sessions | sas-java |
| tomcat_sessions_active_max_sessions | sas-java |
| tomcat_sessions_alive_max_seconds | sas-java |
| tomcat_sessions_created_sessions_total | sas-java |
| tomcat_sessions_expired_sessions_total | sas-java |
| tomcat_sessions_rejected_sessions_total | sas-java |
| zipkin_reporter_messages_bytes_total | sas-java |
| zipkin_reporter_messages_total | sas-java |
| zipkin_reporter_queue_bytes | sas-java |
| zipkin_reporter_queue_spans | sas-java |
| zipkin_reporter_spans_bytes_total | sas-java |
| zipkin_reporter_spans_dropped_total | sas-java |
| zipkin_reporter_spans_total | sas-java |

<b>ClusterName,area,id,job,namespace,node,pod,sas_service_base</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| jvm_memory_committed_bytes | sas-java |
| jvm_memory_max_bytes | sas-java |
| jvm_memory_used_bytes | sas-java |

<b>ClusterName,job,namespace,node,pod,sas_service_base,state</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| jvm_threads_states_threads | sas-java |

<b>ClusterName,job,method,namespace,node,pod,sas_service_base,status,uri</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| http_client_requests_seconds_count | sas-java |
| http_client_requests_seconds_max | sas-java |
| http_client_requests_seconds_sum | sas-java |

<b>ClusterName,job,level,namespace,node,pod,sas_service_base</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| log_events_total | sas-java |

<b>ClusterName,action,cause,job,namespace,node,pod,sas_service_base</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| jvm_gc_pause_seconds_count | sas-java |
| jvm_gc_pause_seconds_max | sas-java |
| jvm_gc_pause_seconds_sum | sas-java |

<b>ClusterName,datname,job,mode,namespace,pod,server,service</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| pg_locks_count | sas-postgres |

<b>ClusterName,backup_type,job,namespace,pod,server,service,stanza</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| ccp_backrest_last_info_backup_runtime_seconds | sas-postgres |
| ccp_backrest_last_info_repo_backup_size_bytes | sas-postgres |
| ccp_backrest_last_info_repo_total_size_bytes | sas-postgres |

<b>ClusterName,dbname,job,namespace,pod,relname,schemaname,server,service</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| ccp_stat_user_tables_analyze_count | sas-postgres |
| ccp_stat_user_tables_autoanalyze_count | sas-postgres |
| ccp_stat_user_tables_autovacuum_count | sas-postgres |
| ccp_stat_user_tables_idx_scan | sas-postgres |
| ccp_stat_user_tables_idx_tup_fetch | sas-postgres |
| ccp_stat_user_tables_n_dead_tup | sas-postgres |
| ccp_stat_user_tables_n_live_tup | sas-postgres |
| ccp_stat_user_tables_n_tup_del | sas-postgres |
| ccp_stat_user_tables_n_tup_hot_upd | sas-postgres |
| ccp_stat_user_tables_n_tup_ins | sas-postgres |
| ccp_stat_user_tables_n_tup_upd | sas-postgres |
| ccp_stat_user_tables_seq_scan | sas-postgres |
| ccp_stat_user_tables_seq_tup_read | sas-postgres |
| ccp_stat_user_tables_vacuum_count | sas-postgres |
| ccp_table_size_size_bytes | sas-postgres |

<b>ClusterName,dbname,job,mode,namespace,pod,server,service</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| ccp_locks_count | sas-postgres |

<b>ClusterName,job,namespace,pod,server,service</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| ccp_archive_command_status_seconds_since_last_fail | sas-postgres |
| ccp_connection_stats_active | sas-postgres |
| ccp_connection_stats_idle | sas-postgres |
| ccp_connection_stats_idle_in_txn | sas-postgres |
| ccp_connection_stats_max_blocked_query_time | sas-postgres |
| ccp_connection_stats_max_connections | sas-postgres |
| ccp_connection_stats_max_idle_in_txn_time | sas-postgres |
| ccp_connection_stats_max_query_time | sas-postgres |
| ccp_connection_stats_total | sas-postgres |
| ccp_data_checksum_failure_time_since_last_failure_seconds | sas-postgres |
| ccp_is_in_recovery_status | sas-postgres |
| ccp_nodemx_cpu_limit | sas-postgres |
| ccp_nodemx_cpu_request | sas-postgres |
| ccp_nodemx_cpuacct_usage | sas-postgres |
| ccp_nodemx_cpucfs_period_us | sas-postgres |
| ccp_nodemx_cpucfs_quota_us | sas-postgres |
| ccp_nodemx_cpustat_nr_periods | sas-postgres |
| ccp_nodemx_cpustat_nr_throttled | sas-postgres |
| ccp_nodemx_cpustat_throttled_time | sas-postgres |
| ccp_nodemx_mem_active_anon | sas-postgres |
| ccp_nodemx_mem_active_file | sas-postgres |
| ccp_nodemx_mem_cache | sas-postgres |
| ccp_nodemx_mem_inactive_anon | sas-postgres |
| ccp_nodemx_mem_inactive_file | sas-postgres |
| ccp_nodemx_mem_limit | sas-postgres |
| ccp_nodemx_mem_mapped_file | sas-postgres |
| ccp_nodemx_mem_request | sas-postgres |
| ccp_nodemx_mem_rss | sas-postgres |
| ccp_nodemx_process_count | sas-postgres |
| ccp_pg_hba_checksum_status | sas-postgres |
| ccp_pg_settings_checksum_status | sas-postgres |
| ccp_postgresql_version_current | sas-postgres |
| ccp_postmaster_runtime_start_time_seconds | sas-postgres |
| ccp_postmaster_uptime_seconds | sas-postgres |
| ccp_replication_lag_replay_time | sas-postgres |
| ccp_sequence_exhaustion_count | sas-postgres |
| ccp_settings_gauge_checkpoint_completion_target | sas-postgres |
| ccp_settings_gauge_checkpoint_timeout | sas-postgres |
| ccp_settings_gauge_shared_buffers | sas-postgres |
| ccp_settings_pending_restart_count | sas-postgres |
| ccp_stat_bgwriter_buffers_alloc | sas-postgres |
| ccp_stat_bgwriter_buffers_backend | sas-postgres |
| ccp_stat_bgwriter_buffers_backend_fsync | sas-postgres |
| ccp_stat_bgwriter_buffers_checkpoint | sas-postgres |
| ccp_stat_bgwriter_buffers_clean | sas-postgres |
| ccp_stat_bgwriter_checkpoint_sync_time | sas-postgres |
| ccp_stat_bgwriter_checkpoint_write_time | sas-postgres |
| ccp_stat_bgwriter_checkpoints_req | sas-postgres |
| ccp_stat_bgwriter_checkpoints_timed | sas-postgres |
| ccp_stat_bgwriter_maxwritten_clean | sas-postgres |
| ccp_stat_bgwriter_stats_reset | sas-postgres |
| ccp_transaction_wraparound_oldest_current_xid | sas-postgres |
| ccp_transaction_wraparound_percent_towards_emergency_autovac | sas-postgres |
| ccp_transaction_wraparound_percent_towards_wraparound | sas-postgres |
| ccp_wal_activity_last_5_min_size_bytes | sas-postgres |
| ccp_wal_activity_total_size_bytes | sas-postgres |
| pg_settings_allow_system_table_mods | sas-postgres |
| pg_settings_archive_timeout_seconds | sas-postgres |
| pg_settings_array_nulls | sas-postgres |
| pg_settings_authentication_timeout_seconds | sas-postgres |
| pg_settings_autovacuum | sas-postgres |
| pg_settings_autovacuum_analyze_scale_factor | sas-postgres |
| pg_settings_autovacuum_analyze_threshold | sas-postgres |
| pg_settings_autovacuum_freeze_max_age | sas-postgres |
| pg_settings_autovacuum_max_workers | sas-postgres |
| pg_settings_autovacuum_multixact_freeze_max_age | sas-postgres |
| pg_settings_autovacuum_naptime_seconds | sas-postgres |
| pg_settings_autovacuum_vacuum_cost_delay_seconds | sas-postgres |
| pg_settings_autovacuum_vacuum_cost_limit | sas-postgres |
| pg_settings_autovacuum_vacuum_scale_factor | sas-postgres |
| pg_settings_autovacuum_vacuum_threshold | sas-postgres |
| pg_settings_autovacuum_work_mem_bytes | sas-postgres |
| pg_settings_backend_flush_after_bytes | sas-postgres |
| pg_settings_bgwriter_delay_seconds | sas-postgres |
| pg_settings_bgwriter_flush_after_bytes | sas-postgres |
| pg_settings_bgwriter_lru_maxpages | sas-postgres |
| pg_settings_bgwriter_lru_multiplier | sas-postgres |
| pg_settings_block_size | sas-postgres |
| pg_settings_bonjour | sas-postgres |
| pg_settings_check_function_bodies | sas-postgres |
| pg_settings_checkpoint_completion_target | sas-postgres |
| pg_settings_checkpoint_flush_after_bytes | sas-postgres |
| pg_settings_checkpoint_timeout_seconds | sas-postgres |
| pg_settings_checkpoint_warning_seconds | sas-postgres |
| pg_settings_commit_delay | sas-postgres |
| pg_settings_commit_siblings | sas-postgres |
| pg_settings_cpu_index_tuple_cost | sas-postgres |
| pg_settings_cpu_operator_cost | sas-postgres |
| pg_settings_cpu_tuple_cost | sas-postgres |
| pg_settings_cursor_tuple_fraction | sas-postgres |
| pg_settings_data_checksums | sas-postgres |
| pg_settings_data_directory_mode | sas-postgres |
| pg_settings_data_sync_retry | sas-postgres |
| pg_settings_db_user_namespace | sas-postgres |
| pg_settings_deadlock_timeout_seconds | sas-postgres |
| pg_settings_debug_assertions | sas-postgres |
| pg_settings_debug_pretty_print | sas-postgres |
| pg_settings_debug_print_parse | sas-postgres |
| pg_settings_debug_print_plan | sas-postgres |
| pg_settings_debug_print_rewritten | sas-postgres |
| pg_settings_default_statistics_target | sas-postgres |
| pg_settings_default_transaction_deferrable | sas-postgres |
| pg_settings_default_transaction_read_only | sas-postgres |
| pg_settings_effective_cache_size_bytes | sas-postgres |
| pg_settings_effective_io_concurrency | sas-postgres |
| pg_settings_enable_bitmapscan | sas-postgres |
| pg_settings_enable_gathermerge | sas-postgres |
| pg_settings_enable_hashagg | sas-postgres |
| pg_settings_enable_hashjoin | sas-postgres |
| pg_settings_enable_indexonlyscan | sas-postgres |
| pg_settings_enable_indexscan | sas-postgres |
| pg_settings_enable_material | sas-postgres |
| pg_settings_enable_mergejoin | sas-postgres |
| pg_settings_enable_nestloop | sas-postgres |
| pg_settings_enable_parallel_append | sas-postgres |
| pg_settings_enable_parallel_hash | sas-postgres |
| pg_settings_enable_partition_pruning | sas-postgres |
| pg_settings_enable_partitionwise_aggregate | sas-postgres |
| pg_settings_enable_partitionwise_join | sas-postgres |
| pg_settings_enable_seqscan | sas-postgres |
| pg_settings_enable_sort | sas-postgres |
| pg_settings_enable_tidscan | sas-postgres |
| pg_settings_escape_string_warning | sas-postgres |
| pg_settings_exit_on_error | sas-postgres |
| pg_settings_extra_float_digits | sas-postgres |
| pg_settings_from_collapse_limit | sas-postgres |
| pg_settings_fsync | sas-postgres |
| pg_settings_full_page_writes | sas-postgres |
| pg_settings_geqo | sas-postgres |
| pg_settings_geqo_effort | sas-postgres |
| pg_settings_geqo_generations | sas-postgres |
| pg_settings_geqo_pool_size | sas-postgres |
| pg_settings_geqo_seed | sas-postgres |
| pg_settings_geqo_selection_bias | sas-postgres |
| pg_settings_geqo_threshold | sas-postgres |
| pg_settings_gin_fuzzy_search_limit | sas-postgres |
| pg_settings_gin_pending_list_limit_bytes | sas-postgres |
| pg_settings_hot_standby | sas-postgres |
| pg_settings_hot_standby_feedback | sas-postgres |
| pg_settings_idle_in_transaction_session_timeout_seconds | sas-postgres |
| pg_settings_ignore_checksum_failure | sas-postgres |
| pg_settings_ignore_system_indexes | sas-postgres |
| pg_settings_integer_datetimes | sas-postgres |
| pg_settings_jit | sas-postgres |
| pg_settings_jit_above_cost | sas-postgres |
| pg_settings_jit_debugging_support | sas-postgres |
| pg_settings_jit_dump_bitcode | sas-postgres |
| pg_settings_jit_expressions | sas-postgres |
| pg_settings_jit_inline_above_cost | sas-postgres |
| pg_settings_jit_optimize_above_cost | sas-postgres |
| pg_settings_jit_profiling_support | sas-postgres |
| pg_settings_jit_tuple_deforming | sas-postgres |
| pg_settings_join_collapse_limit | sas-postgres |
| pg_settings_krb_caseins_users | sas-postgres |
| pg_settings_lo_compat_privileges | sas-postgres |
| pg_settings_lock_timeout_seconds | sas-postgres |
| pg_settings_log_autovacuum_min_duration_seconds | sas-postgres |
| pg_settings_log_checkpoints | sas-postgres |
| pg_settings_log_connections | sas-postgres |
| pg_settings_log_disconnections | sas-postgres |
| pg_settings_log_duration | sas-postgres |
| pg_settings_log_executor_stats | sas-postgres |
| pg_settings_log_file_mode | sas-postgres |
| pg_settings_log_hostname | sas-postgres |
| pg_settings_log_lock_waits | sas-postgres |
| pg_settings_log_min_duration_statement_seconds | sas-postgres |
| pg_settings_log_parser_stats | sas-postgres |
| pg_settings_log_planner_stats | sas-postgres |
| pg_settings_log_replication_commands | sas-postgres |
| pg_settings_log_rotation_age_seconds | sas-postgres |
| pg_settings_log_rotation_size_bytes | sas-postgres |
| pg_settings_log_statement_stats | sas-postgres |
| pg_settings_log_temp_files_bytes | sas-postgres |
| pg_settings_log_transaction_sample_rate | sas-postgres |
| pg_settings_log_truncate_on_rotation | sas-postgres |
| pg_settings_logging_collector | sas-postgres |
| pg_settings_maintenance_work_mem_bytes | sas-postgres |
| pg_settings_max_connections | sas-postgres |
| pg_settings_max_files_per_process | sas-postgres |
| pg_settings_max_function_args | sas-postgres |
| pg_settings_max_identifier_length | sas-postgres |
| pg_settings_max_index_keys | sas-postgres |
| pg_settings_max_locks_per_transaction | sas-postgres |
| pg_settings_max_logical_replication_workers | sas-postgres |
| pg_settings_max_parallel_maintenance_workers | sas-postgres |
| pg_settings_max_parallel_workers | sas-postgres |
| pg_settings_max_parallel_workers_per_gather | sas-postgres |
| pg_settings_max_pred_locks_per_page | sas-postgres |
| pg_settings_max_pred_locks_per_relation | sas-postgres |
| pg_settings_max_pred_locks_per_transaction | sas-postgres |
| pg_settings_max_prepared_transactions | sas-postgres |
| pg_settings_max_replication_slots | sas-postgres |
| pg_settings_max_stack_depth_bytes | sas-postgres |
| pg_settings_max_standby_archive_delay_seconds | sas-postgres |
| pg_settings_max_standby_streaming_delay_seconds | sas-postgres |
| pg_settings_max_sync_workers_per_subscription | sas-postgres |
| pg_settings_max_wal_senders | sas-postgres |
| pg_settings_max_wal_size_bytes | sas-postgres |
| pg_settings_max_worker_processes | sas-postgres |
| pg_settings_min_parallel_index_scan_size_bytes | sas-postgres |
| pg_settings_min_parallel_table_scan_size_bytes | sas-postgres |
| pg_settings_min_wal_size_bytes | sas-postgres |
| pg_settings_old_snapshot_threshold_seconds | sas-postgres |
| pg_settings_operator_precedence_warning | sas-postgres |
| pg_settings_parallel_leader_participation | sas-postgres |
| pg_settings_parallel_setup_cost | sas-postgres |
| pg_settings_parallel_tuple_cost | sas-postgres |
| pg_settings_pg_stat_statements_max | sas-postgres |
| pg_settings_pg_stat_statements_save | sas-postgres |
| pg_settings_pg_stat_statements_track_utility | sas-postgres |
| pg_settings_pgaudit_log_catalog | sas-postgres |
| pg_settings_pgaudit_log_client | sas-postgres |
| pg_settings_pgaudit_log_parameter | sas-postgres |
| pg_settings_pgaudit_log_relation | sas-postgres |
| pg_settings_pgaudit_log_statement_once | sas-postgres |
| pg_settings_pgnodemx_cgroup_enabled | sas-postgres |
| pg_settings_pgnodemx_containerized | sas-postgres |
| pg_settings_pgnodemx_kdapi_enabled | sas-postgres |
| pg_settings_plpgsql_check_asserts | sas-postgres |
| pg_settings_plpgsql_print_strict_params | sas-postgres |
| pg_settings_port | sas-postgres |
| pg_settings_post_auth_delay_seconds | sas-postgres |
| pg_settings_pre_auth_delay_seconds | sas-postgres |
| pg_settings_quote_all_identifiers | sas-postgres |
| pg_settings_random_page_cost | sas-postgres |
| pg_settings_recovery_min_apply_delay_seconds | sas-postgres |
| pg_settings_recovery_target_inclusive | sas-postgres |
| pg_settings_restart_after_crash | sas-postgres |
| pg_settings_row_security | sas-postgres |
| pg_settings_segment_size_bytes | sas-postgres |
| pg_settings_seq_page_cost | sas-postgres |
| pg_settings_server_version_num | sas-postgres |
| pg_settings_shared_buffers_bytes | sas-postgres |
| pg_settings_ssl | sas-postgres |
| pg_settings_ssl_passphrase_command_supports_reload | sas-postgres |
| pg_settings_ssl_prefer_server_ciphers | sas-postgres |
| pg_settings_standard_conforming_strings | sas-postgres |
| pg_settings_statement_timeout_seconds | sas-postgres |
| pg_settings_superuser_reserved_connections | sas-postgres |
| pg_settings_synchronize_seqscans | sas-postgres |
| pg_settings_syslog_sequence_numbers | sas-postgres |
| pg_settings_syslog_split_messages | sas-postgres |
| pg_settings_tcp_keepalives_count | sas-postgres |
| pg_settings_tcp_keepalives_idle_seconds | sas-postgres |
| pg_settings_tcp_keepalives_interval_seconds | sas-postgres |
| pg_settings_tcp_user_timeout_seconds | sas-postgres |
| pg_settings_temp_buffers_bytes | sas-postgres |
| pg_settings_temp_file_limit_bytes | sas-postgres |
| pg_settings_trace_notify | sas-postgres |
| pg_settings_trace_sort | sas-postgres |
| pg_settings_track_activities | sas-postgres |
| pg_settings_track_activity_query_size_bytes | sas-postgres |
| pg_settings_track_commit_timestamp | sas-postgres |
| pg_settings_track_counts | sas-postgres |
| pg_settings_track_io_timing | sas-postgres |
| pg_settings_transaction_deferrable | sas-postgres |
| pg_settings_transaction_read_only | sas-postgres |
| pg_settings_transform_null_equals | sas-postgres |
| pg_settings_unix_socket_permissions | sas-postgres |
| pg_settings_update_process_title | sas-postgres |
| pg_settings_vacuum_cleanup_index_scale_factor | sas-postgres |
| pg_settings_vacuum_cost_delay_seconds | sas-postgres |
| pg_settings_vacuum_cost_limit | sas-postgres |
| pg_settings_vacuum_cost_page_dirty | sas-postgres |
| pg_settings_vacuum_cost_page_hit | sas-postgres |
| pg_settings_vacuum_cost_page_miss | sas-postgres |
| pg_settings_vacuum_defer_cleanup_age | sas-postgres |
| pg_settings_vacuum_freeze_min_age | sas-postgres |
| pg_settings_vacuum_freeze_table_age | sas-postgres |
| pg_settings_vacuum_multixact_freeze_min_age | sas-postgres |
| pg_settings_vacuum_multixact_freeze_table_age | sas-postgres |
| pg_settings_wal_block_size | sas-postgres |
| pg_settings_wal_buffers_bytes | sas-postgres |
| pg_settings_wal_compression | sas-postgres |
| pg_settings_wal_init_zero | sas-postgres |
| pg_settings_wal_keep_segments | sas-postgres |
| pg_settings_wal_log_hints | sas-postgres |
| pg_settings_wal_receiver_status_interval_seconds | sas-postgres |
| pg_settings_wal_receiver_timeout_seconds | sas-postgres |
| pg_settings_wal_recycle | sas-postgres |
| pg_settings_wal_retrieve_retry_interval_seconds | sas-postgres |
| pg_settings_wal_segment_size_bytes | sas-postgres |
| pg_settings_wal_sender_timeout_seconds | sas-postgres |
| pg_settings_wal_writer_delay_seconds | sas-postgres |
| pg_settings_wal_writer_flush_after_bytes | sas-postgres |
| pg_settings_work_mem_bytes | sas-postgres |
| pg_settings_zero_damaged_pages | sas-postgres |
| pg_stat_archiver_archived_count | sas-postgres |
| pg_stat_archiver_failed_count | sas-postgres |
| pg_stat_archiver_last_archive_age | sas-postgres |
| pg_stat_bgwriter_buffers_alloc | sas-postgres |
| pg_stat_bgwriter_buffers_backend | sas-postgres |
| pg_stat_bgwriter_buffers_backend_fsync | sas-postgres |
| pg_stat_bgwriter_buffers_checkpoint | sas-postgres |
| pg_stat_bgwriter_buffers_clean | sas-postgres |
| pg_stat_bgwriter_checkpoint_sync_time | sas-postgres |
| pg_stat_bgwriter_checkpoint_write_time | sas-postgres |
| pg_stat_bgwriter_checkpoints_req | sas-postgres |
| pg_stat_bgwriter_checkpoints_timed | sas-postgres |
| pg_stat_bgwriter_maxwritten_clean | sas-postgres |
| pg_stat_bgwriter_stats_reset | sas-postgres |

<b>ClusterName,dbname,job,namespace,pod,server,service</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| ccp_data_checksum_failure_time_since_last_failure_seconds | sas-postgres |
| ccp_database_size_bytes | sas-postgres |
| ccp_stat_database_blks_hit | sas-postgres |
| ccp_stat_database_blks_read | sas-postgres |
| ccp_stat_database_conflicts | sas-postgres |
| ccp_stat_database_deadlocks | sas-postgres |
| ccp_stat_database_temp_bytes | sas-postgres |
| ccp_stat_database_temp_files | sas-postgres |
| ccp_stat_database_tup_deleted | sas-postgres |
| ccp_stat_database_tup_fetched | sas-postgres |
| ccp_stat_database_tup_inserted | sas-postgres |
| ccp_stat_database_tup_returned | sas-postgres |
| ccp_stat_database_tup_updated | sas-postgres |
| ccp_stat_database_xact_commit | sas-postgres |
| ccp_stat_database_xact_rollback | sas-postgres |

<b>ClusterName,job,namespace,pod,quantile,service</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| go_gc_duration_seconds | sas-postgres |

<b>ClusterName,job,namespace,pod,server,service,stanza</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| ccp_backrest_last_diff_backup_time_since_completion_seconds | sas-postgres |
| ccp_backrest_last_full_backup_time_since_completion_seconds | sas-postgres |
| ccp_backrest_last_incr_backup_time_since_completion_seconds | sas-postgres |

<b>ClusterName,datid,datname,job,namespace,pod,server,service</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| pg_stat_database_blk_read_time | sas-postgres |
| pg_stat_database_blk_write_time | sas-postgres |
| pg_stat_database_blks_hit | sas-postgres |
| pg_stat_database_blks_read | sas-postgres |
| pg_stat_database_conflicts | sas-postgres |
| pg_stat_database_conflicts_confl_bufferpin | sas-postgres |
| pg_stat_database_conflicts_confl_deadlock | sas-postgres |
| pg_stat_database_conflicts_confl_lock | sas-postgres |
| pg_stat_database_conflicts_confl_snapshot | sas-postgres |
| pg_stat_database_conflicts_confl_tablespace | sas-postgres |
| pg_stat_database_deadlocks | sas-postgres |
| pg_stat_database_numbackends | sas-postgres |
| pg_stat_database_stats_reset | sas-postgres |
| pg_stat_database_temp_bytes | sas-postgres |
| pg_stat_database_temp_files | sas-postgres |
| pg_stat_database_tup_deleted | sas-postgres |
| pg_stat_database_tup_fetched | sas-postgres |
| pg_stat_database_tup_inserted | sas-postgres |
| pg_stat_database_tup_returned | sas-postgres |
| pg_stat_database_tup_updated | sas-postgres |
| pg_stat_database_xact_commit | sas-postgres |
| pg_stat_database_xact_rollback | sas-postgres |

<b>ClusterName,job,namespace,pod,replica,replica_port,server,service</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| ccp_replication_lag_size_bytes | sas-postgres |

<b>ClusterName,filename,hashsum,job,namespace,pod,service</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| pg_exporter_user_queries_load_error | sas-postgres |

<b>ClusterName,fs_type,job,mount_point,namespace,pod,server,service</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| ccp_nodemx_data_disk_available_bytes | sas-postgres |
| ccp_nodemx_data_disk_free_file_nodes | sas-postgres |
| ccp_nodemx_data_disk_total_bytes | sas-postgres |
| ccp_nodemx_data_disk_total_file_nodes | sas-postgres |

<b>ClusterName,interface,job,namespace,pod,server,service</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| ccp_nodemx_network_rx_bytes | sas-postgres |
| ccp_nodemx_network_rx_packets | sas-postgres |
| ccp_nodemx_network_tx_bytes | sas-postgres |
| ccp_nodemx_network_tx_packets | sas-postgres |

<b>ClusterName,job,mount_point,namespace,pod,server,service</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| ccp_nodemx_disk_activity_sectors_read | sas-postgres |
| ccp_nodemx_disk_activity_sectors_written | sas-postgres |

<b>ClusterName,datname,job,namespace,pod,server,service,state</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| pg_stat_activity_count | sas-postgres |
| pg_stat_activity_max_tx_duration | sas-postgres |

<b>ClusterName,datid,job,namespace,pod,server,service</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| pg_stat_database_blk_read_time | sas-postgres |
| pg_stat_database_blk_write_time | sas-postgres |
| pg_stat_database_blks_hit | sas-postgres |
| pg_stat_database_blks_read | sas-postgres |
| pg_stat_database_conflicts | sas-postgres |
| pg_stat_database_deadlocks | sas-postgres |
| pg_stat_database_numbackends | sas-postgres |
| pg_stat_database_stats_reset | sas-postgres |
| pg_stat_database_temp_bytes | sas-postgres |
| pg_stat_database_temp_files | sas-postgres |
| pg_stat_database_tup_deleted | sas-postgres |
| pg_stat_database_tup_fetched | sas-postgres |
| pg_stat_database_tup_inserted | sas-postgres |
| pg_stat_database_tup_returned | sas-postgres |
| pg_stat_database_tup_updated | sas-postgres |
| pg_stat_database_xact_commit | sas-postgres |
| pg_stat_database_xact_rollback | sas-postgres |

<b>ClusterName,job,namespace,pod,service</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| go_gc_duration_seconds_count | sas-postgres |
| go_gc_duration_seconds_sum | sas-postgres |
| go_goroutines | sas-postgres |
| go_memstats_alloc_bytes | sas-postgres |
| go_memstats_alloc_bytes_total | sas-postgres |
| go_memstats_buck_hash_sys_bytes | sas-postgres |
| go_memstats_frees_total | sas-postgres |
| go_memstats_gc_cpu_fraction | sas-postgres |
| go_memstats_gc_sys_bytes | sas-postgres |
| go_memstats_heap_alloc_bytes | sas-postgres |
| go_memstats_heap_idle_bytes | sas-postgres |
| go_memstats_heap_inuse_bytes | sas-postgres |
| go_memstats_heap_objects | sas-postgres |
| go_memstats_heap_released_bytes | sas-postgres |
| go_memstats_heap_sys_bytes | sas-postgres |
| go_memstats_last_gc_time_seconds | sas-postgres |
| go_memstats_lookups_total | sas-postgres |
| go_memstats_mallocs_total | sas-postgres |
| go_memstats_mcache_inuse_bytes | sas-postgres |
| go_memstats_mcache_sys_bytes | sas-postgres |
| go_memstats_mspan_inuse_bytes | sas-postgres |
| go_memstats_mspan_sys_bytes | sas-postgres |
| go_memstats_next_gc_bytes | sas-postgres |
| go_memstats_other_sys_bytes | sas-postgres |
| go_memstats_stack_inuse_bytes | sas-postgres |
| go_memstats_stack_sys_bytes | sas-postgres |
| go_memstats_sys_bytes | sas-postgres |
| go_threads | sas-postgres |
| pg_exporter_last_scrape_duration_seconds | sas-postgres |
| pg_exporter_last_scrape_error | sas-postgres |
| pg_exporter_scrapes_total | sas-postgres |
| pg_up | sas-postgres |
| process_cpu_seconds_total | sas-postgres |
| process_max_fds | sas-postgres |
| process_open_fds | sas-postgres |
| process_resident_memory_bytes | sas-postgres |
| process_start_time_seconds | sas-postgres |
| process_virtual_memory_bytes | sas-postgres |
| process_virtual_memory_max_bytes | sas-postgres |

<b>ClusterName,job,namespace,pod,server,service,short_version,version</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| pg_static | sas-postgres |

<b>ClusterName,job,namespace,peer,pod,service,type</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| erlang_vm_dist_proc_heap_size_words | sas-rabbitmq |
| erlang_vm_dist_proc_memory_bytes | sas-rabbitmq |
| erlang_vm_dist_proc_message_queue_len | sas-rabbitmq |
| erlang_vm_dist_proc_min_bin_vheap_size_words | sas-rabbitmq |
| erlang_vm_dist_proc_min_heap_size_words | sas-rabbitmq |
| erlang_vm_dist_proc_reductions | sas-rabbitmq |
| erlang_vm_dist_proc_stack_size_words | sas-rabbitmq |
| erlang_vm_dist_proc_status | sas-rabbitmq |
| erlang_vm_dist_proc_total_heap_size_words | sas-rabbitmq |

<b>ClusterName,content_type,encoding,job,namespace,pod,registry,service</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| telemetry_scrape_encoded_size_bytes_count | sas-rabbitmq |
| telemetry_scrape_encoded_size_bytes_sum | sas-rabbitmq |

<b>ClusterName,id,job,namespace,pod,service,type</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| erlang_vm_msacc_alloc_seconds_total | sas-rabbitmq |
| erlang_vm_msacc_aux_seconds_total | sas-rabbitmq |
| erlang_vm_msacc_bif_seconds_total | sas-rabbitmq |
| erlang_vm_msacc_busy_wait_seconds_total | sas-rabbitmq |
| erlang_vm_msacc_check_io_seconds_total | sas-rabbitmq |
| erlang_vm_msacc_emulator_seconds_total | sas-rabbitmq |
| erlang_vm_msacc_ets_seconds_total | sas-rabbitmq |
| erlang_vm_msacc_gc_full_seconds_total | sas-rabbitmq |
| erlang_vm_msacc_gc_seconds_total | sas-rabbitmq |
| erlang_vm_msacc_nif_seconds_total | sas-rabbitmq |
| erlang_vm_msacc_other_seconds_total | sas-rabbitmq |
| erlang_vm_msacc_port_seconds_total | sas-rabbitmq |
| erlang_vm_msacc_send_seconds_total | sas-rabbitmq |
| erlang_vm_msacc_sleep_seconds_total | sas-rabbitmq |
| erlang_vm_msacc_timers_seconds_total | sas-rabbitmq |

<b>ClusterName,content_type,job,namespace,pod,registry,service</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| telemetry_scrape_duration_seconds_count | sas-rabbitmq |
| telemetry_scrape_duration_seconds_sum | sas-rabbitmq |
| telemetry_scrape_size_bytes_count | sas-rabbitmq |
| telemetry_scrape_size_bytes_sum | sas-rabbitmq |

<b>ClusterName,job,namespace,pod,service,usage</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| erlang_vm_memory_atom_bytes_total | sas-rabbitmq |
| erlang_vm_memory_processes_bytes_total | sas-rabbitmq |
| erlang_vm_memory_system_bytes_total | sas-rabbitmq |

<b>ClusterName,job,kind,namespace,pod,service</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| erlang_vm_memory_bytes_total | sas-rabbitmq |

<b>ClusterName,job,namespace,pod,protocol,service</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| rabbitmq_auth_attempts_failed_total | sas-rabbitmq |
| rabbitmq_auth_attempts_succeeded_total | sas-rabbitmq |
| rabbitmq_auth_attempts_total | sas-rabbitmq |

<b>ClusterName,job,namespace,pod,service</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| erlang_mnesia_committed_transactions | sas-rabbitmq |
| erlang_mnesia_failed_transactions | sas-rabbitmq |
| erlang_mnesia_held_locks | sas-rabbitmq |
| erlang_mnesia_lock_queue | sas-rabbitmq |
| erlang_mnesia_logged_transactions | sas-rabbitmq |
| erlang_mnesia_restarted_transactions | sas-rabbitmq |
| erlang_mnesia_transaction_coordinators | sas-rabbitmq |
| erlang_mnesia_transaction_participants | sas-rabbitmq |
| erlang_vm_atom_count | sas-rabbitmq |
| erlang_vm_atom_limit | sas-rabbitmq |
| erlang_vm_dirty_cpu_schedulers | sas-rabbitmq |
| erlang_vm_dirty_cpu_schedulers_online | sas-rabbitmq |
| erlang_vm_dirty_io_schedulers | sas-rabbitmq |
| erlang_vm_ets_limit | sas-rabbitmq |
| erlang_vm_logical_processors | sas-rabbitmq |
| erlang_vm_logical_processors_available | sas-rabbitmq |
| erlang_vm_logical_processors_online | sas-rabbitmq |
| erlang_vm_memory_dets_tables | sas-rabbitmq |
| erlang_vm_memory_ets_tables | sas-rabbitmq |
| erlang_vm_port_count | sas-rabbitmq |
| erlang_vm_port_limit | sas-rabbitmq |
| erlang_vm_process_count | sas-rabbitmq |
| erlang_vm_process_limit | sas-rabbitmq |
| erlang_vm_schedulers | sas-rabbitmq |
| erlang_vm_schedulers_online | sas-rabbitmq |
| erlang_vm_smp_support | sas-rabbitmq |
| erlang_vm_statistics_bytes_output_total | sas-rabbitmq |
| erlang_vm_statistics_bytes_received_total | sas-rabbitmq |
| erlang_vm_statistics_context_switches | sas-rabbitmq |
| erlang_vm_statistics_dirty_cpu_run_queue_length | sas-rabbitmq |
| erlang_vm_statistics_dirty_io_run_queue_length | sas-rabbitmq |
| erlang_vm_statistics_garbage_collection_bytes_reclaimed | sas-rabbitmq |
| erlang_vm_statistics_garbage_collection_number_of_gcs | sas-rabbitmq |
| erlang_vm_statistics_garbage_collection_words_reclaimed | sas-rabbitmq |
| erlang_vm_statistics_reductions_total | sas-rabbitmq |
| erlang_vm_statistics_run_queues_length_total | sas-rabbitmq |
| erlang_vm_statistics_runtime_milliseconds | sas-rabbitmq |
| erlang_vm_statistics_wallclock_time_milliseconds | sas-rabbitmq |
| erlang_vm_thread_pool_size | sas-rabbitmq |
| erlang_vm_threads | sas-rabbitmq |
| erlang_vm_time_correction | sas-rabbitmq |
| erlang_vm_wordsize_bytes | sas-rabbitmq |
| rabbitmq_channel_acks_uncommitted | sas-rabbitmq |
| rabbitmq_channel_consumers | sas-rabbitmq |
| rabbitmq_channel_get_ack_total | sas-rabbitmq |
| rabbitmq_channel_get_empty_total | sas-rabbitmq |
| rabbitmq_channel_get_total | sas-rabbitmq |
| rabbitmq_channel_messages_acked_total | sas-rabbitmq |
| rabbitmq_channel_messages_confirmed_total | sas-rabbitmq |
| rabbitmq_channel_messages_delivered_ack_total | sas-rabbitmq |
| rabbitmq_channel_messages_delivered_total | sas-rabbitmq |
| rabbitmq_channel_messages_published_total | sas-rabbitmq |
| rabbitmq_channel_messages_redelivered_total | sas-rabbitmq |
| rabbitmq_channel_messages_unacked | sas-rabbitmq |
| rabbitmq_channel_messages_uncommitted | sas-rabbitmq |
| rabbitmq_channel_messages_unconfirmed | sas-rabbitmq |
| rabbitmq_channel_messages_unroutable_dropped_total | sas-rabbitmq |
| rabbitmq_channel_messages_unroutable_returned_total | sas-rabbitmq |
| rabbitmq_channel_prefetch | sas-rabbitmq |
| rabbitmq_channel_process_reductions_total | sas-rabbitmq |
| rabbitmq_channels | sas-rabbitmq |
| rabbitmq_channels_closed_total | sas-rabbitmq |
| rabbitmq_channels_opened_total | sas-rabbitmq |
| rabbitmq_connection_channels | sas-rabbitmq |
| rabbitmq_connection_incoming_bytes_total | sas-rabbitmq |
| rabbitmq_connection_incoming_packets_total | sas-rabbitmq |
| rabbitmq_connection_outgoing_bytes_total | sas-rabbitmq |
| rabbitmq_connection_outgoing_packets_total | sas-rabbitmq |
| rabbitmq_connection_pending_packets | sas-rabbitmq |
| rabbitmq_connection_process_reductions_total | sas-rabbitmq |
| rabbitmq_connections | sas-rabbitmq |
| rabbitmq_connections_closed_total | sas-rabbitmq |
| rabbitmq_connections_opened_total | sas-rabbitmq |
| rabbitmq_consumer_prefetch | sas-rabbitmq |
| rabbitmq_consumers | sas-rabbitmq |
| rabbitmq_disk_space_available_bytes | sas-rabbitmq |
| rabbitmq_disk_space_available_limit_bytes | sas-rabbitmq |
| rabbitmq_erlang_gc_reclaimed_bytes_total | sas-rabbitmq |
| rabbitmq_erlang_gc_runs_total | sas-rabbitmq |
| rabbitmq_erlang_net_ticktime_seconds | sas-rabbitmq |
| rabbitmq_erlang_processes_limit | sas-rabbitmq |
| rabbitmq_erlang_processes_used | sas-rabbitmq |
| rabbitmq_erlang_scheduler_context_switches_total | sas-rabbitmq |
| rabbitmq_erlang_scheduler_run_queue | sas-rabbitmq |
| rabbitmq_erlang_uptime_seconds | sas-rabbitmq |
| rabbitmq_io_open_attempt_ops_total | sas-rabbitmq |
| rabbitmq_io_open_attempt_time_seconds_total | sas-rabbitmq |
| rabbitmq_io_read_bytes_total | sas-rabbitmq |
| rabbitmq_io_read_ops_total | sas-rabbitmq |
| rabbitmq_io_read_time_seconds_total | sas-rabbitmq |
| rabbitmq_io_reopen_ops_total | sas-rabbitmq |
| rabbitmq_io_seek_ops_total | sas-rabbitmq |
| rabbitmq_io_seek_time_seconds_total | sas-rabbitmq |
| rabbitmq_io_sync_ops_total | sas-rabbitmq |
| rabbitmq_io_sync_time_seconds_total | sas-rabbitmq |
| rabbitmq_io_write_bytes_total | sas-rabbitmq |
| rabbitmq_io_write_ops_total | sas-rabbitmq |
| rabbitmq_io_write_time_seconds_total | sas-rabbitmq |
| rabbitmq_msg_store_read_total | sas-rabbitmq |
| rabbitmq_msg_store_write_total | sas-rabbitmq |
| rabbitmq_process_max_fds | sas-rabbitmq |
| rabbitmq_process_max_tcp_sockets | sas-rabbitmq |
| rabbitmq_process_open_fds | sas-rabbitmq |
| rabbitmq_process_open_tcp_sockets | sas-rabbitmq |
| rabbitmq_process_resident_memory_bytes | sas-rabbitmq |
| rabbitmq_queue_consumer_utilisation | sas-rabbitmq |
| rabbitmq_queue_consumers | sas-rabbitmq |
| rabbitmq_queue_disk_reads_total | sas-rabbitmq |
| rabbitmq_queue_disk_writes_total | sas-rabbitmq |
| rabbitmq_queue_index_journal_write_ops_total | sas-rabbitmq |
| rabbitmq_queue_index_read_ops_total | sas-rabbitmq |
| rabbitmq_queue_index_write_ops_total | sas-rabbitmq |
| rabbitmq_queue_messages | sas-rabbitmq |
| rabbitmq_queue_messages_bytes | sas-rabbitmq |
| rabbitmq_queue_messages_paged_out | sas-rabbitmq |
| rabbitmq_queue_messages_paged_out_bytes | sas-rabbitmq |
| rabbitmq_queue_messages_persistent | sas-rabbitmq |
| rabbitmq_queue_messages_published_total | sas-rabbitmq |
| rabbitmq_queue_messages_ram | sas-rabbitmq |
| rabbitmq_queue_messages_ram_bytes | sas-rabbitmq |
| rabbitmq_queue_messages_ready | sas-rabbitmq |
| rabbitmq_queue_messages_ready_bytes | sas-rabbitmq |
| rabbitmq_queue_messages_ready_ram | sas-rabbitmq |
| rabbitmq_queue_messages_unacked | sas-rabbitmq |
| rabbitmq_queue_messages_unacked_bytes | sas-rabbitmq |
| rabbitmq_queue_messages_unacked_ram | sas-rabbitmq |
| rabbitmq_queue_process_memory_bytes | sas-rabbitmq |
| rabbitmq_queue_process_reductions_total | sas-rabbitmq |
| rabbitmq_queues | sas-rabbitmq |
| rabbitmq_queues_created_total | sas-rabbitmq |
| rabbitmq_queues_declared_total | sas-rabbitmq |
| rabbitmq_queues_deleted_total | sas-rabbitmq |
| rabbitmq_raft_entry_commit_latency_seconds | sas-rabbitmq |
| rabbitmq_raft_log_commit_index | sas-rabbitmq |
| rabbitmq_raft_log_last_applied_index | sas-rabbitmq |
| rabbitmq_raft_log_last_written_index | sas-rabbitmq |
| rabbitmq_raft_log_snapshot_index | sas-rabbitmq |
| rabbitmq_raft_term_total | sas-rabbitmq |
| rabbitmq_resident_memory_limit_bytes | sas-rabbitmq |
| rabbitmq_schema_db_disk_tx_total | sas-rabbitmq |
| rabbitmq_schema_db_ram_tx_total | sas-rabbitmq |

<b>ClusterName,alloc,instance_no,job,kind,namespace,pod,service,usage</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| erlang_vm_allocators | sas-rabbitmq |

<b>ClusterName,job,namespace,peer,pod,service</b>

| Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ------ | ------ |
| erlang_vm_dist_node_queue_size_bytes | sas-rabbitmq |
| erlang_vm_dist_node_state | sas-rabbitmq |
| erlang_vm_dist_port_input_bytes | sas-rabbitmq |
| erlang_vm_dist_port_memory_bytes | sas-rabbitmq |
| erlang_vm_dist_port_output_bytes | sas-rabbitmq |
| erlang_vm_dist_port_queue_size_bytes | sas-rabbitmq |
| erlang_vm_dist_recv_avg_bytes | sas-rabbitmq |
| erlang_vm_dist_recv_bytes | sas-rabbitmq |
| erlang_vm_dist_recv_cnt | sas-rabbitmq |
| erlang_vm_dist_recv_dvi_bytes | sas-rabbitmq |
| erlang_vm_dist_recv_max_bytes | sas-rabbitmq |
| erlang_vm_dist_send_avg_bytes | sas-rabbitmq |
| erlang_vm_dist_send_bytes | sas-rabbitmq |
| erlang_vm_dist_send_cnt | sas-rabbitmq |
| erlang_vm_dist_send_max_bytes | sas-rabbitmq |
| erlang_vm_dist_send_pend_bytes | sas-rabbitmq |

</details>

## By Source
lists the dimensions and metrics associated with each type of metric source (such as CAS, SAS services written in Go, or SAS services written in Java)
<details>
  <summary>Click to expand</summary>
<b>sas-cas</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,cas_node,cas_node_type,cas_server,job,namespace,pod,type | cas_node_cpu_time_seconds |
| ClusterName,cas_node,cas_node_type,cas_server,job,namespace,pod,type | cas_node_mem_free_bytes |
| ClusterName,cas_node,cas_node_type,cas_server,job,namespace,pod,type | cas_node_mem_size_bytes |

<b>sas-cas</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,cas_node,cas_node_type,cas_server,job,namespace,pod | cas_node_fifteen_minute_cpu_load_avg |
| ClusterName,cas_node,cas_node_type,cas_server,job,namespace,pod | cas_node_five_minute_cpu_load_avg |
| ClusterName,cas_node,cas_node_type,cas_server,job,namespace,pod | cas_node_free_files |
| ClusterName,cas_node,cas_node_type,cas_server,job,namespace,pod | cas_node_inodes_free |
| ClusterName,cas_node,cas_node_type,cas_server,job,namespace,pod | cas_node_inodes_used |
| ClusterName,cas_node,cas_node_type,cas_server,job,namespace,pod | cas_node_max_open_files |
| ClusterName,cas_node,cas_node_type,cas_server,job,namespace,pod | cas_node_one_minute_cpu_load_avg |
| ClusterName,cas_node,cas_node_type,cas_server,job,namespace,pod | cas_node_open_files |

<b>sas-cas</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,cas_node,cas_node_type,cas_server,connected,job,namespace,pod,uuid | cas_nodes |

<b>sas-cas</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,cas_server,job,namespace,pod | cas_grid_idle_seconds |
| ClusterName,cas_server,job,namespace,pod | cas_grid_sessions_created_total |
| ClusterName,cas_server,job,namespace,pod | cas_grid_sessions_current |
| ClusterName,cas_server,job,namespace,pod | cas_grid_sessions_max |
| ClusterName,cas_server,job,namespace,pod | cas_grid_start_time_seconds |
| ClusterName,cas_server,job,namespace,pod | cas_grid_uptime_seconds_total |

<b>sas-cas</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,cas_server,job,namespace,pod,state | cas_grid_state |

<b>sas-go</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,job,method,namespace,node,pod,quantile,sas_service_base,service,status | arke_request_elapsed |

<b>sas-go</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,job,namespace,node,pod,reason,sas_service_base,schema,service | sas_db_closed_total |

<b>sas-go</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,job,namespace,node,pod,sas_service_base,service,state | sas_db_connections_max |
| ClusterName,job,namespace,node,pod,sas_service_base,service,state | sas_db_pool_connections |

<b>sas-go</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,job,namespace,node,pod,sas_service_base,schema,service | sas_db_wait_seconds |
| ClusterName,job,namespace,node,pod,sas_service_base,schema,service | sas_db_wait_total |

<b>sas-go</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,job,namespace,node,pod,sas_service_base,service | arke_client_active_messages |
| ClusterName,job,namespace,node,pod,sas_service_base,service | arke_client_consumed_total |
| ClusterName,job,namespace,node,pod,sas_service_base,service | arke_client_produced_total |
| ClusterName,job,namespace,node,pod,sas_service_base,service | arke_client_streams |
| ClusterName,job,namespace,node,pod,sas_service_base,service | arke_recvmsg_total |
| ClusterName,job,namespace,node,pod,sas_service_base,service | arke_request_elapsed_count |
| ClusterName,job,namespace,node,pod,sas_service_base,service | arke_request_elapsed_sum |
| ClusterName,job,namespace,node,pod,sas_service_base,service | arke_request_total |
| ClusterName,job,namespace,node,pod,sas_service_base,service | arke_sendmsg_total |
| ClusterName,job,namespace,node,pod,sas_service_base,service | go_gc_duration_seconds_count |
| ClusterName,job,namespace,node,pod,sas_service_base,service | go_gc_duration_seconds_sum |
| ClusterName,job,namespace,node,pod,sas_service_base,service | go_goroutines |
| ClusterName,job,namespace,node,pod,sas_service_base,service | go_memstats_alloc_bytes |
| ClusterName,job,namespace,node,pod,sas_service_base,service | go_memstats_alloc_bytes_total |
| ClusterName,job,namespace,node,pod,sas_service_base,service | go_memstats_buck_hash_sys_bytes |
| ClusterName,job,namespace,node,pod,sas_service_base,service | go_memstats_frees_total |
| ClusterName,job,namespace,node,pod,sas_service_base,service | go_memstats_gc_cpu_fraction |
| ClusterName,job,namespace,node,pod,sas_service_base,service | go_memstats_gc_sys_bytes |
| ClusterName,job,namespace,node,pod,sas_service_base,service | go_memstats_heap_alloc_bytes |
| ClusterName,job,namespace,node,pod,sas_service_base,service | go_memstats_heap_idle_bytes |
| ClusterName,job,namespace,node,pod,sas_service_base,service | go_memstats_heap_inuse_bytes |
| ClusterName,job,namespace,node,pod,sas_service_base,service | go_memstats_heap_objects |
| ClusterName,job,namespace,node,pod,sas_service_base,service | go_memstats_heap_released_bytes |
| ClusterName,job,namespace,node,pod,sas_service_base,service | go_memstats_heap_sys_bytes |
| ClusterName,job,namespace,node,pod,sas_service_base,service | go_memstats_last_gc_time_seconds |
| ClusterName,job,namespace,node,pod,sas_service_base,service | go_memstats_lookups_total |
| ClusterName,job,namespace,node,pod,sas_service_base,service | go_memstats_mallocs_total |
| ClusterName,job,namespace,node,pod,sas_service_base,service | go_memstats_mcache_inuse_bytes |
| ClusterName,job,namespace,node,pod,sas_service_base,service | go_memstats_mcache_sys_bytes |
| ClusterName,job,namespace,node,pod,sas_service_base,service | go_memstats_mspan_inuse_bytes |
| ClusterName,job,namespace,node,pod,sas_service_base,service | go_memstats_mspan_sys_bytes |
| ClusterName,job,namespace,node,pod,sas_service_base,service | go_memstats_next_gc_bytes |
| ClusterName,job,namespace,node,pod,sas_service_base,service | go_memstats_other_sys_bytes |
| ClusterName,job,namespace,node,pod,sas_service_base,service | go_memstats_stack_inuse_bytes |
| ClusterName,job,namespace,node,pod,sas_service_base,service | go_memstats_stack_sys_bytes |
| ClusterName,job,namespace,node,pod,sas_service_base,service | go_memstats_sys_bytes |
| ClusterName,job,namespace,node,pod,sas_service_base,service | go_threads |
| ClusterName,job,namespace,node,pod,sas_service_base,service | process_cpu_seconds_total |
| ClusterName,job,namespace,node,pod,sas_service_base,service | process_max_fds |
| ClusterName,job,namespace,node,pod,sas_service_base,service | process_open_fds |
| ClusterName,job,namespace,node,pod,sas_service_base,service | process_resident_memory_bytes |
| ClusterName,job,namespace,node,pod,sas_service_base,service | process_start_time_seconds |
| ClusterName,job,namespace,node,pod,sas_service_base,service | process_virtual_memory_bytes |
| ClusterName,job,namespace,node,pod,sas_service_base,service | process_virtual_memory_max_bytes |
| ClusterName,job,namespace,node,pod,sas_service_base,service | runtime_alloc_bytes |
| ClusterName,job,namespace,node,pod,sas_service_base,service | runtime_free_count |
| ClusterName,job,namespace,node,pod,sas_service_base,service | runtime_gc_pause_ns_count |
| ClusterName,job,namespace,node,pod,sas_service_base,service | runtime_gc_pause_ns_sum |
| ClusterName,job,namespace,node,pod,sas_service_base,service | runtime_heap_objects |
| ClusterName,job,namespace,node,pod,sas_service_base,service | runtime_malloc_count |
| ClusterName,job,namespace,node,pod,sas_service_base,service | runtime_num_goroutines |
| ClusterName,job,namespace,node,pod,sas_service_base,service | runtime_sys_bytes |
| ClusterName,job,namespace,node,pod,sas_service_base,service | runtime_total_gc_pause_ns |
| ClusterName,job,namespace,node,pod,sas_service_base,service | runtime_total_gc_runs |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas_db_wait_seconds |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas_db_wait_total |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas_maps_esri_query_duration_seconds_count |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas_maps_esri_query_duration_seconds_sum |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas_maps_report_polling_attempts_total |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas_maps_report_query_duration_seconds_count |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas_maps_report_query_duration_seconds_sum |

<b>sas-go</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,job,namespace,node,pod,reason,sas_service_base,service | sas_db_closed_total |

<b>sas-go</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClientIdentitifer,ClusterName,job,namespace,node,pod,sas_service_base,service | arke_client_active_messages |
| ClientIdentitifer,ClusterName,job,namespace,node,pod,sas_service_base,service | arke_client_consumed_total |
| ClientIdentitifer,ClusterName,job,namespace,node,pod,sas_service_base,service | arke_client_produced_total |
| ClientIdentitifer,ClusterName,job,namespace,node,pod,sas_service_base,service | arke_client_streams |

<b>sas-go</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,job,namespace,node,pod,quantile,sas_service_base,service | go_gc_duration_seconds |
| ClusterName,job,namespace,node,pod,quantile,sas_service_base,service | runtime_gc_pause_ns |

<b>sas-go</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,job,level,namespace,node,pod,sas_service_base,service | log_events_total |

<b>sas-go</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,job,namespace,node,pod,sas_service_base,schema,service,state | sas_db_connections_max |
| ClusterName,job,namespace,node,pod,sas_service_base,schema,service,state | sas_db_pool_connections |

<b>sas-go</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,job,method,namespace,node,pod,sas_service_base,service,status | arke_recvmsg_total |
| ClusterName,job,method,namespace,node,pod,sas_service_base,service,status | arke_request_elapsed_count |
| ClusterName,job,method,namespace,node,pod,sas_service_base,service,status | arke_request_elapsed_sum |
| ClusterName,job,method,namespace,node,pod,sas_service_base,service,status | arke_request_total |
| ClusterName,job,method,namespace,node,pod,sas_service_base,service,status | arke_sendmsg_total |

<b>sas-java</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,id,job,namespace,node,pod,sas_service_base | jvm_buffer_count_buffers |
| ClusterName,id,job,namespace,node,pod,sas_service_base | jvm_buffer_memory_used_bytes |
| ClusterName,id,job,namespace,node,pod,sas_service_base | jvm_buffer_total_capacity_bytes |

<b>sas-java</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,job,listener_id,namespace,node,pod,queue,result,sas_service_base | spring_rabbitmq_listener_seconds_count |
| ClusterName,job,listener_id,namespace,node,pod,queue,result,sas_service_base | spring_rabbitmq_listener_seconds_max |
| ClusterName,job,listener_id,namespace,node,pod,queue,result,sas_service_base | spring_rabbitmq_listener_seconds_sum |

<b>sas-java</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,job,method,namespace,node,outcome,pod,sas_service_base,status,uri | http_server_requests_seconds_count |
| ClusterName,job,method,namespace,node,outcome,pod,sas_service_base,status,uri | http_server_requests_seconds_max |
| ClusterName,job,method,namespace,node,outcome,pod,sas_service_base,status,uri | http_server_requests_seconds_sum |

<b>sas-java</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,job,name,namespace,node,pod,sas_service_base | jdbc_connections_active |
| ClusterName,job,name,namespace,node,pod,sas_service_base | jdbc_connections_idle |
| ClusterName,job,name,namespace,node,pod,sas_service_base | jdbc_connections_max |
| ClusterName,job,name,namespace,node,pod,sas_service_base | jdbc_connections_min |
| ClusterName,job,name,namespace,node,pod,sas_service_base | rabbitmq_acknowledged_published_total |
| ClusterName,job,name,namespace,node,pod,sas_service_base | rabbitmq_acknowledged_total |
| ClusterName,job,name,namespace,node,pod,sas_service_base | rabbitmq_channels |
| ClusterName,job,name,namespace,node,pod,sas_service_base | rabbitmq_connections |
| ClusterName,job,name,namespace,node,pod,sas_service_base | rabbitmq_consumed_total |
| ClusterName,job,name,namespace,node,pod,sas_service_base | rabbitmq_failed_to_publish_total |
| ClusterName,job,name,namespace,node,pod,sas_service_base | rabbitmq_not_acknowledged_published_total |
| ClusterName,job,name,namespace,node,pod,sas_service_base | rabbitmq_published_total |
| ClusterName,job,name,namespace,node,pod,sas_service_base | rabbitmq_rejected_total |
| ClusterName,job,name,namespace,node,pod,sas_service_base | rabbitmq_unrouted_published_total |
| ClusterName,job,name,namespace,node,pod,sas_service_base | tomcat_global_error_total |
| ClusterName,job,name,namespace,node,pod,sas_service_base | tomcat_global_received_bytes_total |
| ClusterName,job,name,namespace,node,pod,sas_service_base | tomcat_global_request_max_seconds |
| ClusterName,job,name,namespace,node,pod,sas_service_base | tomcat_global_request_seconds_count |
| ClusterName,job,name,namespace,node,pod,sas_service_base | tomcat_global_request_seconds_sum |
| ClusterName,job,name,namespace,node,pod,sas_service_base | tomcat_global_sent_bytes_total |
| ClusterName,job,name,namespace,node,pod,sas_service_base | tomcat_servlet_error_total |
| ClusterName,job,name,namespace,node,pod,sas_service_base | tomcat_servlet_request_max_seconds |
| ClusterName,job,name,namespace,node,pod,sas_service_base | tomcat_servlet_request_seconds_count |
| ClusterName,job,name,namespace,node,pod,sas_service_base | tomcat_servlet_request_seconds_sum |
| ClusterName,job,name,namespace,node,pod,sas_service_base | tomcat_threads_busy_threads |
| ClusterName,job,name,namespace,node,pod,sas_service_base | tomcat_threads_config_max_threads |
| ClusterName,job,name,namespace,node,pod,sas_service_base | tomcat_threads_current_threads |

<b>sas-java</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,job,namespace,node,pod,sas_service_base | jvm_classes_loaded_classes |
| ClusterName,job,namespace,node,pod,sas_service_base | jvm_classes_unloaded_classes_total |
| ClusterName,job,namespace,node,pod,sas_service_base | jvm_gc_live_data_size_bytes |
| ClusterName,job,namespace,node,pod,sas_service_base | jvm_gc_max_data_size_bytes |
| ClusterName,job,namespace,node,pod,sas_service_base | jvm_gc_memory_allocated_bytes_total |
| ClusterName,job,namespace,node,pod,sas_service_base | jvm_gc_memory_promoted_bytes_total |
| ClusterName,job,namespace,node,pod,sas_service_base | jvm_threads_daemon_threads |
| ClusterName,job,namespace,node,pod,sas_service_base | jvm_threads_live_threads |
| ClusterName,job,namespace,node,pod,sas_service_base | jvm_threads_peak_threads |
| ClusterName,job,namespace,node,pod,sas_service_base | process_cpu_usage |
| ClusterName,job,namespace,node,pod,sas_service_base | process_files_max_files |
| ClusterName,job,namespace,node,pod,sas_service_base | process_files_open_files |
| ClusterName,job,namespace,node,pod,sas_service_base | process_start_time_seconds |
| ClusterName,job,namespace,node,pod,sas_service_base | process_uptime_seconds |
| ClusterName,job,namespace,node,pod,sas_service_base | spring_integration_channels |
| ClusterName,job,namespace,node,pod,sas_service_base | spring_integration_handlers |
| ClusterName,job,namespace,node,pod,sas_service_base | spring_integration_sources |
| ClusterName,job,namespace,node,pod,sas_service_base | system_cpu_count |
| ClusterName,job,namespace,node,pod,sas_service_base | system_cpu_usage |
| ClusterName,job,namespace,node,pod,sas_service_base | system_load_average_1m |
| ClusterName,job,namespace,node,pod,sas_service_base | tomcat_cache_access_total |
| ClusterName,job,namespace,node,pod,sas_service_base | tomcat_cache_hit_total |
| ClusterName,job,namespace,node,pod,sas_service_base | tomcat_sessions_active_current_sessions |
| ClusterName,job,namespace,node,pod,sas_service_base | tomcat_sessions_active_max_sessions |
| ClusterName,job,namespace,node,pod,sas_service_base | tomcat_sessions_alive_max_seconds |
| ClusterName,job,namespace,node,pod,sas_service_base | tomcat_sessions_created_sessions_total |
| ClusterName,job,namespace,node,pod,sas_service_base | tomcat_sessions_expired_sessions_total |
| ClusterName,job,namespace,node,pod,sas_service_base | tomcat_sessions_rejected_sessions_total |
| ClusterName,job,namespace,node,pod,sas_service_base | zipkin_reporter_messages_bytes_total |
| ClusterName,job,namespace,node,pod,sas_service_base | zipkin_reporter_messages_total |
| ClusterName,job,namespace,node,pod,sas_service_base | zipkin_reporter_queue_bytes |
| ClusterName,job,namespace,node,pod,sas_service_base | zipkin_reporter_queue_spans |
| ClusterName,job,namespace,node,pod,sas_service_base | zipkin_reporter_spans_bytes_total |
| ClusterName,job,namespace,node,pod,sas_service_base | zipkin_reporter_spans_dropped_total |
| ClusterName,job,namespace,node,pod,sas_service_base | zipkin_reporter_spans_total |

<b>sas-java</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,area,id,job,namespace,node,pod,sas_service_base | jvm_memory_committed_bytes |
| ClusterName,area,id,job,namespace,node,pod,sas_service_base | jvm_memory_max_bytes |
| ClusterName,area,id,job,namespace,node,pod,sas_service_base | jvm_memory_used_bytes |

<b>sas-java</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,job,namespace,node,pod,sas_service_base,state | jvm_threads_states_threads |

<b>sas-java</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,job,method,namespace,node,pod,sas_service_base,status,uri | http_client_requests_seconds_count |
| ClusterName,job,method,namespace,node,pod,sas_service_base,status,uri | http_client_requests_seconds_max |
| ClusterName,job,method,namespace,node,pod,sas_service_base,status,uri | http_client_requests_seconds_sum |

<b>sas-java</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,job,level,namespace,node,pod,sas_service_base | log_events_total |

<b>sas-java</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,action,cause,job,namespace,node,pod,sas_service_base | jvm_gc_pause_seconds_count |
| ClusterName,action,cause,job,namespace,node,pod,sas_service_base | jvm_gc_pause_seconds_max |
| ClusterName,action,cause,job,namespace,node,pod,sas_service_base | jvm_gc_pause_seconds_sum |

<b>sas-postgres</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,datname,job,mode,namespace,pod,server,service | pg_locks_count |

<b>sas-postgres</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,backup_type,job,namespace,pod,server,service,stanza | ccp_backrest_last_info_backup_runtime_seconds |
| ClusterName,backup_type,job,namespace,pod,server,service,stanza | ccp_backrest_last_info_repo_backup_size_bytes |
| ClusterName,backup_type,job,namespace,pod,server,service,stanza | ccp_backrest_last_info_repo_total_size_bytes |

<b>sas-postgres</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,dbname,job,namespace,pod,relname,schemaname,server,service | ccp_stat_user_tables_analyze_count |
| ClusterName,dbname,job,namespace,pod,relname,schemaname,server,service | ccp_stat_user_tables_autoanalyze_count |
| ClusterName,dbname,job,namespace,pod,relname,schemaname,server,service | ccp_stat_user_tables_autovacuum_count |
| ClusterName,dbname,job,namespace,pod,relname,schemaname,server,service | ccp_stat_user_tables_idx_scan |
| ClusterName,dbname,job,namespace,pod,relname,schemaname,server,service | ccp_stat_user_tables_idx_tup_fetch |
| ClusterName,dbname,job,namespace,pod,relname,schemaname,server,service | ccp_stat_user_tables_n_dead_tup |
| ClusterName,dbname,job,namespace,pod,relname,schemaname,server,service | ccp_stat_user_tables_n_live_tup |
| ClusterName,dbname,job,namespace,pod,relname,schemaname,server,service | ccp_stat_user_tables_n_tup_del |
| ClusterName,dbname,job,namespace,pod,relname,schemaname,server,service | ccp_stat_user_tables_n_tup_hot_upd |
| ClusterName,dbname,job,namespace,pod,relname,schemaname,server,service | ccp_stat_user_tables_n_tup_ins |
| ClusterName,dbname,job,namespace,pod,relname,schemaname,server,service | ccp_stat_user_tables_n_tup_upd |
| ClusterName,dbname,job,namespace,pod,relname,schemaname,server,service | ccp_stat_user_tables_seq_scan |
| ClusterName,dbname,job,namespace,pod,relname,schemaname,server,service | ccp_stat_user_tables_seq_tup_read |
| ClusterName,dbname,job,namespace,pod,relname,schemaname,server,service | ccp_stat_user_tables_vacuum_count |
| ClusterName,dbname,job,namespace,pod,relname,schemaname,server,service | ccp_table_size_size_bytes |

<b>sas-postgres</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,dbname,job,mode,namespace,pod,server,service | ccp_locks_count |

<b>sas-postgres</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,job,namespace,pod,server,service | ccp_archive_command_status_seconds_since_last_fail |
| ClusterName,job,namespace,pod,server,service | ccp_connection_stats_active |
| ClusterName,job,namespace,pod,server,service | ccp_connection_stats_idle |
| ClusterName,job,namespace,pod,server,service | ccp_connection_stats_idle_in_txn |
| ClusterName,job,namespace,pod,server,service | ccp_connection_stats_max_blocked_query_time |
| ClusterName,job,namespace,pod,server,service | ccp_connection_stats_max_connections |
| ClusterName,job,namespace,pod,server,service | ccp_connection_stats_max_idle_in_txn_time |
| ClusterName,job,namespace,pod,server,service | ccp_connection_stats_max_query_time |
| ClusterName,job,namespace,pod,server,service | ccp_connection_stats_total |
| ClusterName,job,namespace,pod,server,service | ccp_data_checksum_failure_time_since_last_failure_seconds |
| ClusterName,job,namespace,pod,server,service | ccp_is_in_recovery_status |
| ClusterName,job,namespace,pod,server,service | ccp_nodemx_cpu_limit |
| ClusterName,job,namespace,pod,server,service | ccp_nodemx_cpu_request |
| ClusterName,job,namespace,pod,server,service | ccp_nodemx_cpuacct_usage |
| ClusterName,job,namespace,pod,server,service | ccp_nodemx_cpucfs_period_us |
| ClusterName,job,namespace,pod,server,service | ccp_nodemx_cpucfs_quota_us |
| ClusterName,job,namespace,pod,server,service | ccp_nodemx_cpustat_nr_periods |
| ClusterName,job,namespace,pod,server,service | ccp_nodemx_cpustat_nr_throttled |
| ClusterName,job,namespace,pod,server,service | ccp_nodemx_cpustat_throttled_time |
| ClusterName,job,namespace,pod,server,service | ccp_nodemx_mem_active_anon |
| ClusterName,job,namespace,pod,server,service | ccp_nodemx_mem_active_file |
| ClusterName,job,namespace,pod,server,service | ccp_nodemx_mem_cache |
| ClusterName,job,namespace,pod,server,service | ccp_nodemx_mem_inactive_anon |
| ClusterName,job,namespace,pod,server,service | ccp_nodemx_mem_inactive_file |
| ClusterName,job,namespace,pod,server,service | ccp_nodemx_mem_limit |
| ClusterName,job,namespace,pod,server,service | ccp_nodemx_mem_mapped_file |
| ClusterName,job,namespace,pod,server,service | ccp_nodemx_mem_request |
| ClusterName,job,namespace,pod,server,service | ccp_nodemx_mem_rss |
| ClusterName,job,namespace,pod,server,service | ccp_nodemx_process_count |
| ClusterName,job,namespace,pod,server,service | ccp_pg_hba_checksum_status |
| ClusterName,job,namespace,pod,server,service | ccp_pg_settings_checksum_status |
| ClusterName,job,namespace,pod,server,service | ccp_postgresql_version_current |
| ClusterName,job,namespace,pod,server,service | ccp_postmaster_runtime_start_time_seconds |
| ClusterName,job,namespace,pod,server,service | ccp_postmaster_uptime_seconds |
| ClusterName,job,namespace,pod,server,service | ccp_replication_lag_replay_time |
| ClusterName,job,namespace,pod,server,service | ccp_sequence_exhaustion_count |
| ClusterName,job,namespace,pod,server,service | ccp_settings_gauge_checkpoint_completion_target |
| ClusterName,job,namespace,pod,server,service | ccp_settings_gauge_checkpoint_timeout |
| ClusterName,job,namespace,pod,server,service | ccp_settings_gauge_shared_buffers |
| ClusterName,job,namespace,pod,server,service | ccp_settings_pending_restart_count |
| ClusterName,job,namespace,pod,server,service | ccp_stat_bgwriter_buffers_alloc |
| ClusterName,job,namespace,pod,server,service | ccp_stat_bgwriter_buffers_backend |
| ClusterName,job,namespace,pod,server,service | ccp_stat_bgwriter_buffers_backend_fsync |
| ClusterName,job,namespace,pod,server,service | ccp_stat_bgwriter_buffers_checkpoint |
| ClusterName,job,namespace,pod,server,service | ccp_stat_bgwriter_buffers_clean |
| ClusterName,job,namespace,pod,server,service | ccp_stat_bgwriter_checkpoint_sync_time |
| ClusterName,job,namespace,pod,server,service | ccp_stat_bgwriter_checkpoint_write_time |
| ClusterName,job,namespace,pod,server,service | ccp_stat_bgwriter_checkpoints_req |
| ClusterName,job,namespace,pod,server,service | ccp_stat_bgwriter_checkpoints_timed |
| ClusterName,job,namespace,pod,server,service | ccp_stat_bgwriter_maxwritten_clean |
| ClusterName,job,namespace,pod,server,service | ccp_stat_bgwriter_stats_reset |
| ClusterName,job,namespace,pod,server,service | ccp_transaction_wraparound_oldest_current_xid |
| ClusterName,job,namespace,pod,server,service | ccp_transaction_wraparound_percent_towards_emergency_autovac |
| ClusterName,job,namespace,pod,server,service | ccp_transaction_wraparound_percent_towards_wraparound |
| ClusterName,job,namespace,pod,server,service | ccp_wal_activity_last_5_min_size_bytes |
| ClusterName,job,namespace,pod,server,service | ccp_wal_activity_total_size_bytes |
| ClusterName,job,namespace,pod,server,service | pg_settings_allow_system_table_mods |
| ClusterName,job,namespace,pod,server,service | pg_settings_archive_timeout_seconds |
| ClusterName,job,namespace,pod,server,service | pg_settings_array_nulls |
| ClusterName,job,namespace,pod,server,service | pg_settings_authentication_timeout_seconds |
| ClusterName,job,namespace,pod,server,service | pg_settings_autovacuum |
| ClusterName,job,namespace,pod,server,service | pg_settings_autovacuum_analyze_scale_factor |
| ClusterName,job,namespace,pod,server,service | pg_settings_autovacuum_analyze_threshold |
| ClusterName,job,namespace,pod,server,service | pg_settings_autovacuum_freeze_max_age |
| ClusterName,job,namespace,pod,server,service | pg_settings_autovacuum_max_workers |
| ClusterName,job,namespace,pod,server,service | pg_settings_autovacuum_multixact_freeze_max_age |
| ClusterName,job,namespace,pod,server,service | pg_settings_autovacuum_naptime_seconds |
| ClusterName,job,namespace,pod,server,service | pg_settings_autovacuum_vacuum_cost_delay_seconds |
| ClusterName,job,namespace,pod,server,service | pg_settings_autovacuum_vacuum_cost_limit |
| ClusterName,job,namespace,pod,server,service | pg_settings_autovacuum_vacuum_scale_factor |
| ClusterName,job,namespace,pod,server,service | pg_settings_autovacuum_vacuum_threshold |
| ClusterName,job,namespace,pod,server,service | pg_settings_autovacuum_work_mem_bytes |
| ClusterName,job,namespace,pod,server,service | pg_settings_backend_flush_after_bytes |
| ClusterName,job,namespace,pod,server,service | pg_settings_bgwriter_delay_seconds |
| ClusterName,job,namespace,pod,server,service | pg_settings_bgwriter_flush_after_bytes |
| ClusterName,job,namespace,pod,server,service | pg_settings_bgwriter_lru_maxpages |
| ClusterName,job,namespace,pod,server,service | pg_settings_bgwriter_lru_multiplier |
| ClusterName,job,namespace,pod,server,service | pg_settings_block_size |
| ClusterName,job,namespace,pod,server,service | pg_settings_bonjour |
| ClusterName,job,namespace,pod,server,service | pg_settings_check_function_bodies |
| ClusterName,job,namespace,pod,server,service | pg_settings_checkpoint_completion_target |
| ClusterName,job,namespace,pod,server,service | pg_settings_checkpoint_flush_after_bytes |
| ClusterName,job,namespace,pod,server,service | pg_settings_checkpoint_timeout_seconds |
| ClusterName,job,namespace,pod,server,service | pg_settings_checkpoint_warning_seconds |
| ClusterName,job,namespace,pod,server,service | pg_settings_commit_delay |
| ClusterName,job,namespace,pod,server,service | pg_settings_commit_siblings |
| ClusterName,job,namespace,pod,server,service | pg_settings_cpu_index_tuple_cost |
| ClusterName,job,namespace,pod,server,service | pg_settings_cpu_operator_cost |
| ClusterName,job,namespace,pod,server,service | pg_settings_cpu_tuple_cost |
| ClusterName,job,namespace,pod,server,service | pg_settings_cursor_tuple_fraction |
| ClusterName,job,namespace,pod,server,service | pg_settings_data_checksums |
| ClusterName,job,namespace,pod,server,service | pg_settings_data_directory_mode |
| ClusterName,job,namespace,pod,server,service | pg_settings_data_sync_retry |
| ClusterName,job,namespace,pod,server,service | pg_settings_db_user_namespace |
| ClusterName,job,namespace,pod,server,service | pg_settings_deadlock_timeout_seconds |
| ClusterName,job,namespace,pod,server,service | pg_settings_debug_assertions |
| ClusterName,job,namespace,pod,server,service | pg_settings_debug_pretty_print |
| ClusterName,job,namespace,pod,server,service | pg_settings_debug_print_parse |
| ClusterName,job,namespace,pod,server,service | pg_settings_debug_print_plan |
| ClusterName,job,namespace,pod,server,service | pg_settings_debug_print_rewritten |
| ClusterName,job,namespace,pod,server,service | pg_settings_default_statistics_target |
| ClusterName,job,namespace,pod,server,service | pg_settings_default_transaction_deferrable |
| ClusterName,job,namespace,pod,server,service | pg_settings_default_transaction_read_only |
| ClusterName,job,namespace,pod,server,service | pg_settings_effective_cache_size_bytes |
| ClusterName,job,namespace,pod,server,service | pg_settings_effective_io_concurrency |
| ClusterName,job,namespace,pod,server,service | pg_settings_enable_bitmapscan |
| ClusterName,job,namespace,pod,server,service | pg_settings_enable_gathermerge |
| ClusterName,job,namespace,pod,server,service | pg_settings_enable_hashagg |
| ClusterName,job,namespace,pod,server,service | pg_settings_enable_hashjoin |
| ClusterName,job,namespace,pod,server,service | pg_settings_enable_indexonlyscan |
| ClusterName,job,namespace,pod,server,service | pg_settings_enable_indexscan |
| ClusterName,job,namespace,pod,server,service | pg_settings_enable_material |
| ClusterName,job,namespace,pod,server,service | pg_settings_enable_mergejoin |
| ClusterName,job,namespace,pod,server,service | pg_settings_enable_nestloop |
| ClusterName,job,namespace,pod,server,service | pg_settings_enable_parallel_append |
| ClusterName,job,namespace,pod,server,service | pg_settings_enable_parallel_hash |
| ClusterName,job,namespace,pod,server,service | pg_settings_enable_partition_pruning |
| ClusterName,job,namespace,pod,server,service | pg_settings_enable_partitionwise_aggregate |
| ClusterName,job,namespace,pod,server,service | pg_settings_enable_partitionwise_join |
| ClusterName,job,namespace,pod,server,service | pg_settings_enable_seqscan |
| ClusterName,job,namespace,pod,server,service | pg_settings_enable_sort |
| ClusterName,job,namespace,pod,server,service | pg_settings_enable_tidscan |
| ClusterName,job,namespace,pod,server,service | pg_settings_escape_string_warning |
| ClusterName,job,namespace,pod,server,service | pg_settings_exit_on_error |
| ClusterName,job,namespace,pod,server,service | pg_settings_extra_float_digits |
| ClusterName,job,namespace,pod,server,service | pg_settings_from_collapse_limit |
| ClusterName,job,namespace,pod,server,service | pg_settings_fsync |
| ClusterName,job,namespace,pod,server,service | pg_settings_full_page_writes |
| ClusterName,job,namespace,pod,server,service | pg_settings_geqo |
| ClusterName,job,namespace,pod,server,service | pg_settings_geqo_effort |
| ClusterName,job,namespace,pod,server,service | pg_settings_geqo_generations |
| ClusterName,job,namespace,pod,server,service | pg_settings_geqo_pool_size |
| ClusterName,job,namespace,pod,server,service | pg_settings_geqo_seed |
| ClusterName,job,namespace,pod,server,service | pg_settings_geqo_selection_bias |
| ClusterName,job,namespace,pod,server,service | pg_settings_geqo_threshold |
| ClusterName,job,namespace,pod,server,service | pg_settings_gin_fuzzy_search_limit |
| ClusterName,job,namespace,pod,server,service | pg_settings_gin_pending_list_limit_bytes |
| ClusterName,job,namespace,pod,server,service | pg_settings_hot_standby |
| ClusterName,job,namespace,pod,server,service | pg_settings_hot_standby_feedback |
| ClusterName,job,namespace,pod,server,service | pg_settings_idle_in_transaction_session_timeout_seconds |
| ClusterName,job,namespace,pod,server,service | pg_settings_ignore_checksum_failure |
| ClusterName,job,namespace,pod,server,service | pg_settings_ignore_system_indexes |
| ClusterName,job,namespace,pod,server,service | pg_settings_integer_datetimes |
| ClusterName,job,namespace,pod,server,service | pg_settings_jit |
| ClusterName,job,namespace,pod,server,service | pg_settings_jit_above_cost |
| ClusterName,job,namespace,pod,server,service | pg_settings_jit_debugging_support |
| ClusterName,job,namespace,pod,server,service | pg_settings_jit_dump_bitcode |
| ClusterName,job,namespace,pod,server,service | pg_settings_jit_expressions |
| ClusterName,job,namespace,pod,server,service | pg_settings_jit_inline_above_cost |
| ClusterName,job,namespace,pod,server,service | pg_settings_jit_optimize_above_cost |
| ClusterName,job,namespace,pod,server,service | pg_settings_jit_profiling_support |
| ClusterName,job,namespace,pod,server,service | pg_settings_jit_tuple_deforming |
| ClusterName,job,namespace,pod,server,service | pg_settings_join_collapse_limit |
| ClusterName,job,namespace,pod,server,service | pg_settings_krb_caseins_users |
| ClusterName,job,namespace,pod,server,service | pg_settings_lo_compat_privileges |
| ClusterName,job,namespace,pod,server,service | pg_settings_lock_timeout_seconds |
| ClusterName,job,namespace,pod,server,service | pg_settings_log_autovacuum_min_duration_seconds |
| ClusterName,job,namespace,pod,server,service | pg_settings_log_checkpoints |
| ClusterName,job,namespace,pod,server,service | pg_settings_log_connections |
| ClusterName,job,namespace,pod,server,service | pg_settings_log_disconnections |
| ClusterName,job,namespace,pod,server,service | pg_settings_log_duration |
| ClusterName,job,namespace,pod,server,service | pg_settings_log_executor_stats |
| ClusterName,job,namespace,pod,server,service | pg_settings_log_file_mode |
| ClusterName,job,namespace,pod,server,service | pg_settings_log_hostname |
| ClusterName,job,namespace,pod,server,service | pg_settings_log_lock_waits |
| ClusterName,job,namespace,pod,server,service | pg_settings_log_min_duration_statement_seconds |
| ClusterName,job,namespace,pod,server,service | pg_settings_log_parser_stats |
| ClusterName,job,namespace,pod,server,service | pg_settings_log_planner_stats |
| ClusterName,job,namespace,pod,server,service | pg_settings_log_replication_commands |
| ClusterName,job,namespace,pod,server,service | pg_settings_log_rotation_age_seconds |
| ClusterName,job,namespace,pod,server,service | pg_settings_log_rotation_size_bytes |
| ClusterName,job,namespace,pod,server,service | pg_settings_log_statement_stats |
| ClusterName,job,namespace,pod,server,service | pg_settings_log_temp_files_bytes |
| ClusterName,job,namespace,pod,server,service | pg_settings_log_transaction_sample_rate |
| ClusterName,job,namespace,pod,server,service | pg_settings_log_truncate_on_rotation |
| ClusterName,job,namespace,pod,server,service | pg_settings_logging_collector |
| ClusterName,job,namespace,pod,server,service | pg_settings_maintenance_work_mem_bytes |
| ClusterName,job,namespace,pod,server,service | pg_settings_max_connections |
| ClusterName,job,namespace,pod,server,service | pg_settings_max_files_per_process |
| ClusterName,job,namespace,pod,server,service | pg_settings_max_function_args |
| ClusterName,job,namespace,pod,server,service | pg_settings_max_identifier_length |
| ClusterName,job,namespace,pod,server,service | pg_settings_max_index_keys |
| ClusterName,job,namespace,pod,server,service | pg_settings_max_locks_per_transaction |
| ClusterName,job,namespace,pod,server,service | pg_settings_max_logical_replication_workers |
| ClusterName,job,namespace,pod,server,service | pg_settings_max_parallel_maintenance_workers |
| ClusterName,job,namespace,pod,server,service | pg_settings_max_parallel_workers |
| ClusterName,job,namespace,pod,server,service | pg_settings_max_parallel_workers_per_gather |
| ClusterName,job,namespace,pod,server,service | pg_settings_max_pred_locks_per_page |
| ClusterName,job,namespace,pod,server,service | pg_settings_max_pred_locks_per_relation |
| ClusterName,job,namespace,pod,server,service | pg_settings_max_pred_locks_per_transaction |
| ClusterName,job,namespace,pod,server,service | pg_settings_max_prepared_transactions |
| ClusterName,job,namespace,pod,server,service | pg_settings_max_replication_slots |
| ClusterName,job,namespace,pod,server,service | pg_settings_max_stack_depth_bytes |
| ClusterName,job,namespace,pod,server,service | pg_settings_max_standby_archive_delay_seconds |
| ClusterName,job,namespace,pod,server,service | pg_settings_max_standby_streaming_delay_seconds |
| ClusterName,job,namespace,pod,server,service | pg_settings_max_sync_workers_per_subscription |
| ClusterName,job,namespace,pod,server,service | pg_settings_max_wal_senders |
| ClusterName,job,namespace,pod,server,service | pg_settings_max_wal_size_bytes |
| ClusterName,job,namespace,pod,server,service | pg_settings_max_worker_processes |
| ClusterName,job,namespace,pod,server,service | pg_settings_min_parallel_index_scan_size_bytes |
| ClusterName,job,namespace,pod,server,service | pg_settings_min_parallel_table_scan_size_bytes |
| ClusterName,job,namespace,pod,server,service | pg_settings_min_wal_size_bytes |
| ClusterName,job,namespace,pod,server,service | pg_settings_old_snapshot_threshold_seconds |
| ClusterName,job,namespace,pod,server,service | pg_settings_operator_precedence_warning |
| ClusterName,job,namespace,pod,server,service | pg_settings_parallel_leader_participation |
| ClusterName,job,namespace,pod,server,service | pg_settings_parallel_setup_cost |
| ClusterName,job,namespace,pod,server,service | pg_settings_parallel_tuple_cost |
| ClusterName,job,namespace,pod,server,service | pg_settings_pg_stat_statements_max |
| ClusterName,job,namespace,pod,server,service | pg_settings_pg_stat_statements_save |
| ClusterName,job,namespace,pod,server,service | pg_settings_pg_stat_statements_track_utility |
| ClusterName,job,namespace,pod,server,service | pg_settings_pgaudit_log_catalog |
| ClusterName,job,namespace,pod,server,service | pg_settings_pgaudit_log_client |
| ClusterName,job,namespace,pod,server,service | pg_settings_pgaudit_log_parameter |
| ClusterName,job,namespace,pod,server,service | pg_settings_pgaudit_log_relation |
| ClusterName,job,namespace,pod,server,service | pg_settings_pgaudit_log_statement_once |
| ClusterName,job,namespace,pod,server,service | pg_settings_pgnodemx_cgroup_enabled |
| ClusterName,job,namespace,pod,server,service | pg_settings_pgnodemx_containerized |
| ClusterName,job,namespace,pod,server,service | pg_settings_pgnodemx_kdapi_enabled |
| ClusterName,job,namespace,pod,server,service | pg_settings_plpgsql_check_asserts |
| ClusterName,job,namespace,pod,server,service | pg_settings_plpgsql_print_strict_params |
| ClusterName,job,namespace,pod,server,service | pg_settings_port |
| ClusterName,job,namespace,pod,server,service | pg_settings_post_auth_delay_seconds |
| ClusterName,job,namespace,pod,server,service | pg_settings_pre_auth_delay_seconds |
| ClusterName,job,namespace,pod,server,service | pg_settings_quote_all_identifiers |
| ClusterName,job,namespace,pod,server,service | pg_settings_random_page_cost |
| ClusterName,job,namespace,pod,server,service | pg_settings_recovery_min_apply_delay_seconds |
| ClusterName,job,namespace,pod,server,service | pg_settings_recovery_target_inclusive |
| ClusterName,job,namespace,pod,server,service | pg_settings_restart_after_crash |
| ClusterName,job,namespace,pod,server,service | pg_settings_row_security |
| ClusterName,job,namespace,pod,server,service | pg_settings_segment_size_bytes |
| ClusterName,job,namespace,pod,server,service | pg_settings_seq_page_cost |
| ClusterName,job,namespace,pod,server,service | pg_settings_server_version_num |
| ClusterName,job,namespace,pod,server,service | pg_settings_shared_buffers_bytes |
| ClusterName,job,namespace,pod,server,service | pg_settings_ssl |
| ClusterName,job,namespace,pod,server,service | pg_settings_ssl_passphrase_command_supports_reload |
| ClusterName,job,namespace,pod,server,service | pg_settings_ssl_prefer_server_ciphers |
| ClusterName,job,namespace,pod,server,service | pg_settings_standard_conforming_strings |
| ClusterName,job,namespace,pod,server,service | pg_settings_statement_timeout_seconds |
| ClusterName,job,namespace,pod,server,service | pg_settings_superuser_reserved_connections |
| ClusterName,job,namespace,pod,server,service | pg_settings_synchronize_seqscans |
| ClusterName,job,namespace,pod,server,service | pg_settings_syslog_sequence_numbers |
| ClusterName,job,namespace,pod,server,service | pg_settings_syslog_split_messages |
| ClusterName,job,namespace,pod,server,service | pg_settings_tcp_keepalives_count |
| ClusterName,job,namespace,pod,server,service | pg_settings_tcp_keepalives_idle_seconds |
| ClusterName,job,namespace,pod,server,service | pg_settings_tcp_keepalives_interval_seconds |
| ClusterName,job,namespace,pod,server,service | pg_settings_tcp_user_timeout_seconds |
| ClusterName,job,namespace,pod,server,service | pg_settings_temp_buffers_bytes |
| ClusterName,job,namespace,pod,server,service | pg_settings_temp_file_limit_bytes |
| ClusterName,job,namespace,pod,server,service | pg_settings_trace_notify |
| ClusterName,job,namespace,pod,server,service | pg_settings_trace_sort |
| ClusterName,job,namespace,pod,server,service | pg_settings_track_activities |
| ClusterName,job,namespace,pod,server,service | pg_settings_track_activity_query_size_bytes |
| ClusterName,job,namespace,pod,server,service | pg_settings_track_commit_timestamp |
| ClusterName,job,namespace,pod,server,service | pg_settings_track_counts |
| ClusterName,job,namespace,pod,server,service | pg_settings_track_io_timing |
| ClusterName,job,namespace,pod,server,service | pg_settings_transaction_deferrable |
| ClusterName,job,namespace,pod,server,service | pg_settings_transaction_read_only |
| ClusterName,job,namespace,pod,server,service | pg_settings_transform_null_equals |
| ClusterName,job,namespace,pod,server,service | pg_settings_unix_socket_permissions |
| ClusterName,job,namespace,pod,server,service | pg_settings_update_process_title |
| ClusterName,job,namespace,pod,server,service | pg_settings_vacuum_cleanup_index_scale_factor |
| ClusterName,job,namespace,pod,server,service | pg_settings_vacuum_cost_delay_seconds |
| ClusterName,job,namespace,pod,server,service | pg_settings_vacuum_cost_limit |
| ClusterName,job,namespace,pod,server,service | pg_settings_vacuum_cost_page_dirty |
| ClusterName,job,namespace,pod,server,service | pg_settings_vacuum_cost_page_hit |
| ClusterName,job,namespace,pod,server,service | pg_settings_vacuum_cost_page_miss |
| ClusterName,job,namespace,pod,server,service | pg_settings_vacuum_defer_cleanup_age |
| ClusterName,job,namespace,pod,server,service | pg_settings_vacuum_freeze_min_age |
| ClusterName,job,namespace,pod,server,service | pg_settings_vacuum_freeze_table_age |
| ClusterName,job,namespace,pod,server,service | pg_settings_vacuum_multixact_freeze_min_age |
| ClusterName,job,namespace,pod,server,service | pg_settings_vacuum_multixact_freeze_table_age |
| ClusterName,job,namespace,pod,server,service | pg_settings_wal_block_size |
| ClusterName,job,namespace,pod,server,service | pg_settings_wal_buffers_bytes |
| ClusterName,job,namespace,pod,server,service | pg_settings_wal_compression |
| ClusterName,job,namespace,pod,server,service | pg_settings_wal_init_zero |
| ClusterName,job,namespace,pod,server,service | pg_settings_wal_keep_segments |
| ClusterName,job,namespace,pod,server,service | pg_settings_wal_log_hints |
| ClusterName,job,namespace,pod,server,service | pg_settings_wal_receiver_status_interval_seconds |
| ClusterName,job,namespace,pod,server,service | pg_settings_wal_receiver_timeout_seconds |
| ClusterName,job,namespace,pod,server,service | pg_settings_wal_recycle |
| ClusterName,job,namespace,pod,server,service | pg_settings_wal_retrieve_retry_interval_seconds |
| ClusterName,job,namespace,pod,server,service | pg_settings_wal_segment_size_bytes |
| ClusterName,job,namespace,pod,server,service | pg_settings_wal_sender_timeout_seconds |
| ClusterName,job,namespace,pod,server,service | pg_settings_wal_writer_delay_seconds |
| ClusterName,job,namespace,pod,server,service | pg_settings_wal_writer_flush_after_bytes |
| ClusterName,job,namespace,pod,server,service | pg_settings_work_mem_bytes |
| ClusterName,job,namespace,pod,server,service | pg_settings_zero_damaged_pages |
| ClusterName,job,namespace,pod,server,service | pg_stat_archiver_archived_count |
| ClusterName,job,namespace,pod,server,service | pg_stat_archiver_failed_count |
| ClusterName,job,namespace,pod,server,service | pg_stat_archiver_last_archive_age |
| ClusterName,job,namespace,pod,server,service | pg_stat_bgwriter_buffers_alloc |
| ClusterName,job,namespace,pod,server,service | pg_stat_bgwriter_buffers_backend |
| ClusterName,job,namespace,pod,server,service | pg_stat_bgwriter_buffers_backend_fsync |
| ClusterName,job,namespace,pod,server,service | pg_stat_bgwriter_buffers_checkpoint |
| ClusterName,job,namespace,pod,server,service | pg_stat_bgwriter_buffers_clean |
| ClusterName,job,namespace,pod,server,service | pg_stat_bgwriter_checkpoint_sync_time |
| ClusterName,job,namespace,pod,server,service | pg_stat_bgwriter_checkpoint_write_time |
| ClusterName,job,namespace,pod,server,service | pg_stat_bgwriter_checkpoints_req |
| ClusterName,job,namespace,pod,server,service | pg_stat_bgwriter_checkpoints_timed |
| ClusterName,job,namespace,pod,server,service | pg_stat_bgwriter_maxwritten_clean |
| ClusterName,job,namespace,pod,server,service | pg_stat_bgwriter_stats_reset |

<b>sas-postgres</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,dbname,job,namespace,pod,server,service | ccp_data_checksum_failure_time_since_last_failure_seconds |
| ClusterName,dbname,job,namespace,pod,server,service | ccp_database_size_bytes |
| ClusterName,dbname,job,namespace,pod,server,service | ccp_stat_database_blks_hit |
| ClusterName,dbname,job,namespace,pod,server,service | ccp_stat_database_blks_read |
| ClusterName,dbname,job,namespace,pod,server,service | ccp_stat_database_conflicts |
| ClusterName,dbname,job,namespace,pod,server,service | ccp_stat_database_deadlocks |
| ClusterName,dbname,job,namespace,pod,server,service | ccp_stat_database_temp_bytes |
| ClusterName,dbname,job,namespace,pod,server,service | ccp_stat_database_temp_files |
| ClusterName,dbname,job,namespace,pod,server,service | ccp_stat_database_tup_deleted |
| ClusterName,dbname,job,namespace,pod,server,service | ccp_stat_database_tup_fetched |
| ClusterName,dbname,job,namespace,pod,server,service | ccp_stat_database_tup_inserted |
| ClusterName,dbname,job,namespace,pod,server,service | ccp_stat_database_tup_returned |
| ClusterName,dbname,job,namespace,pod,server,service | ccp_stat_database_tup_updated |
| ClusterName,dbname,job,namespace,pod,server,service | ccp_stat_database_xact_commit |
| ClusterName,dbname,job,namespace,pod,server,service | ccp_stat_database_xact_rollback |

<b>sas-postgres</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,job,namespace,pod,quantile,service | go_gc_duration_seconds |

<b>sas-postgres</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,job,namespace,pod,server,service,stanza | ccp_backrest_last_diff_backup_time_since_completion_seconds |
| ClusterName,job,namespace,pod,server,service,stanza | ccp_backrest_last_full_backup_time_since_completion_seconds |
| ClusterName,job,namespace,pod,server,service,stanza | ccp_backrest_last_incr_backup_time_since_completion_seconds |

<b>sas-postgres</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,datid,datname,job,namespace,pod,server,service | pg_stat_database_blk_read_time |
| ClusterName,datid,datname,job,namespace,pod,server,service | pg_stat_database_blk_write_time |
| ClusterName,datid,datname,job,namespace,pod,server,service | pg_stat_database_blks_hit |
| ClusterName,datid,datname,job,namespace,pod,server,service | pg_stat_database_blks_read |
| ClusterName,datid,datname,job,namespace,pod,server,service | pg_stat_database_conflicts |
| ClusterName,datid,datname,job,namespace,pod,server,service | pg_stat_database_conflicts_confl_bufferpin |
| ClusterName,datid,datname,job,namespace,pod,server,service | pg_stat_database_conflicts_confl_deadlock |
| ClusterName,datid,datname,job,namespace,pod,server,service | pg_stat_database_conflicts_confl_lock |
| ClusterName,datid,datname,job,namespace,pod,server,service | pg_stat_database_conflicts_confl_snapshot |
| ClusterName,datid,datname,job,namespace,pod,server,service | pg_stat_database_conflicts_confl_tablespace |
| ClusterName,datid,datname,job,namespace,pod,server,service | pg_stat_database_deadlocks |
| ClusterName,datid,datname,job,namespace,pod,server,service | pg_stat_database_numbackends |
| ClusterName,datid,datname,job,namespace,pod,server,service | pg_stat_database_stats_reset |
| ClusterName,datid,datname,job,namespace,pod,server,service | pg_stat_database_temp_bytes |
| ClusterName,datid,datname,job,namespace,pod,server,service | pg_stat_database_temp_files |
| ClusterName,datid,datname,job,namespace,pod,server,service | pg_stat_database_tup_deleted |
| ClusterName,datid,datname,job,namespace,pod,server,service | pg_stat_database_tup_fetched |
| ClusterName,datid,datname,job,namespace,pod,server,service | pg_stat_database_tup_inserted |
| ClusterName,datid,datname,job,namespace,pod,server,service | pg_stat_database_tup_returned |
| ClusterName,datid,datname,job,namespace,pod,server,service | pg_stat_database_tup_updated |
| ClusterName,datid,datname,job,namespace,pod,server,service | pg_stat_database_xact_commit |
| ClusterName,datid,datname,job,namespace,pod,server,service | pg_stat_database_xact_rollback |

<b>sas-postgres</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,job,namespace,pod,replica,replica_port,server,service | ccp_replication_lag_size_bytes |

<b>sas-postgres</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,filename,hashsum,job,namespace,pod,service | pg_exporter_user_queries_load_error |

<b>sas-postgres</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,fs_type,job,mount_point,namespace,pod,server,service | ccp_nodemx_data_disk_available_bytes |
| ClusterName,fs_type,job,mount_point,namespace,pod,server,service | ccp_nodemx_data_disk_free_file_nodes |
| ClusterName,fs_type,job,mount_point,namespace,pod,server,service | ccp_nodemx_data_disk_total_bytes |
| ClusterName,fs_type,job,mount_point,namespace,pod,server,service | ccp_nodemx_data_disk_total_file_nodes |

<b>sas-postgres</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,interface,job,namespace,pod,server,service | ccp_nodemx_network_rx_bytes |
| ClusterName,interface,job,namespace,pod,server,service | ccp_nodemx_network_rx_packets |
| ClusterName,interface,job,namespace,pod,server,service | ccp_nodemx_network_tx_bytes |
| ClusterName,interface,job,namespace,pod,server,service | ccp_nodemx_network_tx_packets |

<b>sas-postgres</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,job,mount_point,namespace,pod,server,service | ccp_nodemx_disk_activity_sectors_read |
| ClusterName,job,mount_point,namespace,pod,server,service | ccp_nodemx_disk_activity_sectors_written |

<b>sas-postgres</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,datname,job,namespace,pod,server,service,state | pg_stat_activity_count |
| ClusterName,datname,job,namespace,pod,server,service,state | pg_stat_activity_max_tx_duration |

<b>sas-postgres</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,datid,job,namespace,pod,server,service | pg_stat_database_blk_read_time |
| ClusterName,datid,job,namespace,pod,server,service | pg_stat_database_blk_write_time |
| ClusterName,datid,job,namespace,pod,server,service | pg_stat_database_blks_hit |
| ClusterName,datid,job,namespace,pod,server,service | pg_stat_database_blks_read |
| ClusterName,datid,job,namespace,pod,server,service | pg_stat_database_conflicts |
| ClusterName,datid,job,namespace,pod,server,service | pg_stat_database_deadlocks |
| ClusterName,datid,job,namespace,pod,server,service | pg_stat_database_numbackends |
| ClusterName,datid,job,namespace,pod,server,service | pg_stat_database_stats_reset |
| ClusterName,datid,job,namespace,pod,server,service | pg_stat_database_temp_bytes |
| ClusterName,datid,job,namespace,pod,server,service | pg_stat_database_temp_files |
| ClusterName,datid,job,namespace,pod,server,service | pg_stat_database_tup_deleted |
| ClusterName,datid,job,namespace,pod,server,service | pg_stat_database_tup_fetched |
| ClusterName,datid,job,namespace,pod,server,service | pg_stat_database_tup_inserted |
| ClusterName,datid,job,namespace,pod,server,service | pg_stat_database_tup_returned |
| ClusterName,datid,job,namespace,pod,server,service | pg_stat_database_tup_updated |
| ClusterName,datid,job,namespace,pod,server,service | pg_stat_database_xact_commit |
| ClusterName,datid,job,namespace,pod,server,service | pg_stat_database_xact_rollback |

<b>sas-postgres</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,job,namespace,pod,service | go_gc_duration_seconds_count |
| ClusterName,job,namespace,pod,service | go_gc_duration_seconds_sum |
| ClusterName,job,namespace,pod,service | go_goroutines |
| ClusterName,job,namespace,pod,service | go_memstats_alloc_bytes |
| ClusterName,job,namespace,pod,service | go_memstats_alloc_bytes_total |
| ClusterName,job,namespace,pod,service | go_memstats_buck_hash_sys_bytes |
| ClusterName,job,namespace,pod,service | go_memstats_frees_total |
| ClusterName,job,namespace,pod,service | go_memstats_gc_cpu_fraction |
| ClusterName,job,namespace,pod,service | go_memstats_gc_sys_bytes |
| ClusterName,job,namespace,pod,service | go_memstats_heap_alloc_bytes |
| ClusterName,job,namespace,pod,service | go_memstats_heap_idle_bytes |
| ClusterName,job,namespace,pod,service | go_memstats_heap_inuse_bytes |
| ClusterName,job,namespace,pod,service | go_memstats_heap_objects |
| ClusterName,job,namespace,pod,service | go_memstats_heap_released_bytes |
| ClusterName,job,namespace,pod,service | go_memstats_heap_sys_bytes |
| ClusterName,job,namespace,pod,service | go_memstats_last_gc_time_seconds |
| ClusterName,job,namespace,pod,service | go_memstats_lookups_total |
| ClusterName,job,namespace,pod,service | go_memstats_mallocs_total |
| ClusterName,job,namespace,pod,service | go_memstats_mcache_inuse_bytes |
| ClusterName,job,namespace,pod,service | go_memstats_mcache_sys_bytes |
| ClusterName,job,namespace,pod,service | go_memstats_mspan_inuse_bytes |
| ClusterName,job,namespace,pod,service | go_memstats_mspan_sys_bytes |
| ClusterName,job,namespace,pod,service | go_memstats_next_gc_bytes |
| ClusterName,job,namespace,pod,service | go_memstats_other_sys_bytes |
| ClusterName,job,namespace,pod,service | go_memstats_stack_inuse_bytes |
| ClusterName,job,namespace,pod,service | go_memstats_stack_sys_bytes |
| ClusterName,job,namespace,pod,service | go_memstats_sys_bytes |
| ClusterName,job,namespace,pod,service | go_threads |
| ClusterName,job,namespace,pod,service | pg_exporter_last_scrape_duration_seconds |
| ClusterName,job,namespace,pod,service | pg_exporter_last_scrape_error |
| ClusterName,job,namespace,pod,service | pg_exporter_scrapes_total |
| ClusterName,job,namespace,pod,service | pg_up |
| ClusterName,job,namespace,pod,service | process_cpu_seconds_total |
| ClusterName,job,namespace,pod,service | process_max_fds |
| ClusterName,job,namespace,pod,service | process_open_fds |
| ClusterName,job,namespace,pod,service | process_resident_memory_bytes |
| ClusterName,job,namespace,pod,service | process_start_time_seconds |
| ClusterName,job,namespace,pod,service | process_virtual_memory_bytes |
| ClusterName,job,namespace,pod,service | process_virtual_memory_max_bytes |

<b>sas-postgres</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,job,namespace,pod,server,service,short_version,version | pg_static |

<b>sas-rabbitmq</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,job,namespace,peer,pod,service,type | erlang_vm_dist_proc_heap_size_words |
| ClusterName,job,namespace,peer,pod,service,type | erlang_vm_dist_proc_memory_bytes |
| ClusterName,job,namespace,peer,pod,service,type | erlang_vm_dist_proc_message_queue_len |
| ClusterName,job,namespace,peer,pod,service,type | erlang_vm_dist_proc_min_bin_vheap_size_words |
| ClusterName,job,namespace,peer,pod,service,type | erlang_vm_dist_proc_min_heap_size_words |
| ClusterName,job,namespace,peer,pod,service,type | erlang_vm_dist_proc_reductions |
| ClusterName,job,namespace,peer,pod,service,type | erlang_vm_dist_proc_stack_size_words |
| ClusterName,job,namespace,peer,pod,service,type | erlang_vm_dist_proc_status |
| ClusterName,job,namespace,peer,pod,service,type | erlang_vm_dist_proc_total_heap_size_words |

<b>sas-rabbitmq</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,content_type,encoding,job,namespace,pod,registry,service | telemetry_scrape_encoded_size_bytes_count |
| ClusterName,content_type,encoding,job,namespace,pod,registry,service | telemetry_scrape_encoded_size_bytes_sum |

<b>sas-rabbitmq</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,id,job,namespace,pod,service,type | erlang_vm_msacc_alloc_seconds_total |
| ClusterName,id,job,namespace,pod,service,type | erlang_vm_msacc_aux_seconds_total |
| ClusterName,id,job,namespace,pod,service,type | erlang_vm_msacc_bif_seconds_total |
| ClusterName,id,job,namespace,pod,service,type | erlang_vm_msacc_busy_wait_seconds_total |
| ClusterName,id,job,namespace,pod,service,type | erlang_vm_msacc_check_io_seconds_total |
| ClusterName,id,job,namespace,pod,service,type | erlang_vm_msacc_emulator_seconds_total |
| ClusterName,id,job,namespace,pod,service,type | erlang_vm_msacc_ets_seconds_total |
| ClusterName,id,job,namespace,pod,service,type | erlang_vm_msacc_gc_full_seconds_total |
| ClusterName,id,job,namespace,pod,service,type | erlang_vm_msacc_gc_seconds_total |
| ClusterName,id,job,namespace,pod,service,type | erlang_vm_msacc_nif_seconds_total |
| ClusterName,id,job,namespace,pod,service,type | erlang_vm_msacc_other_seconds_total |
| ClusterName,id,job,namespace,pod,service,type | erlang_vm_msacc_port_seconds_total |
| ClusterName,id,job,namespace,pod,service,type | erlang_vm_msacc_send_seconds_total |
| ClusterName,id,job,namespace,pod,service,type | erlang_vm_msacc_sleep_seconds_total |
| ClusterName,id,job,namespace,pod,service,type | erlang_vm_msacc_timers_seconds_total |

<b>sas-rabbitmq</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,content_type,job,namespace,pod,registry,service | telemetry_scrape_duration_seconds_count |
| ClusterName,content_type,job,namespace,pod,registry,service | telemetry_scrape_duration_seconds_sum |
| ClusterName,content_type,job,namespace,pod,registry,service | telemetry_scrape_size_bytes_count |
| ClusterName,content_type,job,namespace,pod,registry,service | telemetry_scrape_size_bytes_sum |

<b>sas-rabbitmq</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,job,namespace,pod,service,usage | erlang_vm_memory_atom_bytes_total |
| ClusterName,job,namespace,pod,service,usage | erlang_vm_memory_processes_bytes_total |
| ClusterName,job,namespace,pod,service,usage | erlang_vm_memory_system_bytes_total |

<b>sas-rabbitmq</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,job,kind,namespace,pod,service | erlang_vm_memory_bytes_total |

<b>sas-rabbitmq</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,job,namespace,pod,protocol,service | rabbitmq_auth_attempts_failed_total |
| ClusterName,job,namespace,pod,protocol,service | rabbitmq_auth_attempts_succeeded_total |
| ClusterName,job,namespace,pod,protocol,service | rabbitmq_auth_attempts_total |

<b>sas-rabbitmq</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,job,namespace,pod,service | erlang_mnesia_committed_transactions |
| ClusterName,job,namespace,pod,service | erlang_mnesia_failed_transactions |
| ClusterName,job,namespace,pod,service | erlang_mnesia_held_locks |
| ClusterName,job,namespace,pod,service | erlang_mnesia_lock_queue |
| ClusterName,job,namespace,pod,service | erlang_mnesia_logged_transactions |
| ClusterName,job,namespace,pod,service | erlang_mnesia_restarted_transactions |
| ClusterName,job,namespace,pod,service | erlang_mnesia_transaction_coordinators |
| ClusterName,job,namespace,pod,service | erlang_mnesia_transaction_participants |
| ClusterName,job,namespace,pod,service | erlang_vm_atom_count |
| ClusterName,job,namespace,pod,service | erlang_vm_atom_limit |
| ClusterName,job,namespace,pod,service | erlang_vm_dirty_cpu_schedulers |
| ClusterName,job,namespace,pod,service | erlang_vm_dirty_cpu_schedulers_online |
| ClusterName,job,namespace,pod,service | erlang_vm_dirty_io_schedulers |
| ClusterName,job,namespace,pod,service | erlang_vm_ets_limit |
| ClusterName,job,namespace,pod,service | erlang_vm_logical_processors |
| ClusterName,job,namespace,pod,service | erlang_vm_logical_processors_available |
| ClusterName,job,namespace,pod,service | erlang_vm_logical_processors_online |
| ClusterName,job,namespace,pod,service | erlang_vm_memory_dets_tables |
| ClusterName,job,namespace,pod,service | erlang_vm_memory_ets_tables |
| ClusterName,job,namespace,pod,service | erlang_vm_port_count |
| ClusterName,job,namespace,pod,service | erlang_vm_port_limit |
| ClusterName,job,namespace,pod,service | erlang_vm_process_count |
| ClusterName,job,namespace,pod,service | erlang_vm_process_limit |
| ClusterName,job,namespace,pod,service | erlang_vm_schedulers |
| ClusterName,job,namespace,pod,service | erlang_vm_schedulers_online |
| ClusterName,job,namespace,pod,service | erlang_vm_smp_support |
| ClusterName,job,namespace,pod,service | erlang_vm_statistics_bytes_output_total |
| ClusterName,job,namespace,pod,service | erlang_vm_statistics_bytes_received_total |
| ClusterName,job,namespace,pod,service | erlang_vm_statistics_context_switches |
| ClusterName,job,namespace,pod,service | erlang_vm_statistics_dirty_cpu_run_queue_length |
| ClusterName,job,namespace,pod,service | erlang_vm_statistics_dirty_io_run_queue_length |
| ClusterName,job,namespace,pod,service | erlang_vm_statistics_garbage_collection_bytes_reclaimed |
| ClusterName,job,namespace,pod,service | erlang_vm_statistics_garbage_collection_number_of_gcs |
| ClusterName,job,namespace,pod,service | erlang_vm_statistics_garbage_collection_words_reclaimed |
| ClusterName,job,namespace,pod,service | erlang_vm_statistics_reductions_total |
| ClusterName,job,namespace,pod,service | erlang_vm_statistics_run_queues_length_total |
| ClusterName,job,namespace,pod,service | erlang_vm_statistics_runtime_milliseconds |
| ClusterName,job,namespace,pod,service | erlang_vm_statistics_wallclock_time_milliseconds |
| ClusterName,job,namespace,pod,service | erlang_vm_thread_pool_size |
| ClusterName,job,namespace,pod,service | erlang_vm_threads |
| ClusterName,job,namespace,pod,service | erlang_vm_time_correction |
| ClusterName,job,namespace,pod,service | erlang_vm_wordsize_bytes |
| ClusterName,job,namespace,pod,service | rabbitmq_channel_acks_uncommitted |
| ClusterName,job,namespace,pod,service | rabbitmq_channel_consumers |
| ClusterName,job,namespace,pod,service | rabbitmq_channel_get_ack_total |
| ClusterName,job,namespace,pod,service | rabbitmq_channel_get_empty_total |
| ClusterName,job,namespace,pod,service | rabbitmq_channel_get_total |
| ClusterName,job,namespace,pod,service | rabbitmq_channel_messages_acked_total |
| ClusterName,job,namespace,pod,service | rabbitmq_channel_messages_confirmed_total |
| ClusterName,job,namespace,pod,service | rabbitmq_channel_messages_delivered_ack_total |
| ClusterName,job,namespace,pod,service | rabbitmq_channel_messages_delivered_total |
| ClusterName,job,namespace,pod,service | rabbitmq_channel_messages_published_total |
| ClusterName,job,namespace,pod,service | rabbitmq_channel_messages_redelivered_total |
| ClusterName,job,namespace,pod,service | rabbitmq_channel_messages_unacked |
| ClusterName,job,namespace,pod,service | rabbitmq_channel_messages_uncommitted |
| ClusterName,job,namespace,pod,service | rabbitmq_channel_messages_unconfirmed |
| ClusterName,job,namespace,pod,service | rabbitmq_channel_messages_unroutable_dropped_total |
| ClusterName,job,namespace,pod,service | rabbitmq_channel_messages_unroutable_returned_total |
| ClusterName,job,namespace,pod,service | rabbitmq_channel_prefetch |
| ClusterName,job,namespace,pod,service | rabbitmq_channel_process_reductions_total |
| ClusterName,job,namespace,pod,service | rabbitmq_channels |
| ClusterName,job,namespace,pod,service | rabbitmq_channels_closed_total |
| ClusterName,job,namespace,pod,service | rabbitmq_channels_opened_total |
| ClusterName,job,namespace,pod,service | rabbitmq_connection_channels |
| ClusterName,job,namespace,pod,service | rabbitmq_connection_incoming_bytes_total |
| ClusterName,job,namespace,pod,service | rabbitmq_connection_incoming_packets_total |
| ClusterName,job,namespace,pod,service | rabbitmq_connection_outgoing_bytes_total |
| ClusterName,job,namespace,pod,service | rabbitmq_connection_outgoing_packets_total |
| ClusterName,job,namespace,pod,service | rabbitmq_connection_pending_packets |
| ClusterName,job,namespace,pod,service | rabbitmq_connection_process_reductions_total |
| ClusterName,job,namespace,pod,service | rabbitmq_connections |
| ClusterName,job,namespace,pod,service | rabbitmq_connections_closed_total |
| ClusterName,job,namespace,pod,service | rabbitmq_connections_opened_total |
| ClusterName,job,namespace,pod,service | rabbitmq_consumer_prefetch |
| ClusterName,job,namespace,pod,service | rabbitmq_consumers |
| ClusterName,job,namespace,pod,service | rabbitmq_disk_space_available_bytes |
| ClusterName,job,namespace,pod,service | rabbitmq_disk_space_available_limit_bytes |
| ClusterName,job,namespace,pod,service | rabbitmq_erlang_gc_reclaimed_bytes_total |
| ClusterName,job,namespace,pod,service | rabbitmq_erlang_gc_runs_total |
| ClusterName,job,namespace,pod,service | rabbitmq_erlang_net_ticktime_seconds |
| ClusterName,job,namespace,pod,service | rabbitmq_erlang_processes_limit |
| ClusterName,job,namespace,pod,service | rabbitmq_erlang_processes_used |
| ClusterName,job,namespace,pod,service | rabbitmq_erlang_scheduler_context_switches_total |
| ClusterName,job,namespace,pod,service | rabbitmq_erlang_scheduler_run_queue |
| ClusterName,job,namespace,pod,service | rabbitmq_erlang_uptime_seconds |
| ClusterName,job,namespace,pod,service | rabbitmq_io_open_attempt_ops_total |
| ClusterName,job,namespace,pod,service | rabbitmq_io_open_attempt_time_seconds_total |
| ClusterName,job,namespace,pod,service | rabbitmq_io_read_bytes_total |
| ClusterName,job,namespace,pod,service | rabbitmq_io_read_ops_total |
| ClusterName,job,namespace,pod,service | rabbitmq_io_read_time_seconds_total |
| ClusterName,job,namespace,pod,service | rabbitmq_io_reopen_ops_total |
| ClusterName,job,namespace,pod,service | rabbitmq_io_seek_ops_total |
| ClusterName,job,namespace,pod,service | rabbitmq_io_seek_time_seconds_total |
| ClusterName,job,namespace,pod,service | rabbitmq_io_sync_ops_total |
| ClusterName,job,namespace,pod,service | rabbitmq_io_sync_time_seconds_total |
| ClusterName,job,namespace,pod,service | rabbitmq_io_write_bytes_total |
| ClusterName,job,namespace,pod,service | rabbitmq_io_write_ops_total |
| ClusterName,job,namespace,pod,service | rabbitmq_io_write_time_seconds_total |
| ClusterName,job,namespace,pod,service | rabbitmq_msg_store_read_total |
| ClusterName,job,namespace,pod,service | rabbitmq_msg_store_write_total |
| ClusterName,job,namespace,pod,service | rabbitmq_process_max_fds |
| ClusterName,job,namespace,pod,service | rabbitmq_process_max_tcp_sockets |
| ClusterName,job,namespace,pod,service | rabbitmq_process_open_fds |
| ClusterName,job,namespace,pod,service | rabbitmq_process_open_tcp_sockets |
| ClusterName,job,namespace,pod,service | rabbitmq_process_resident_memory_bytes |
| ClusterName,job,namespace,pod,service | rabbitmq_queue_consumer_utilisation |
| ClusterName,job,namespace,pod,service | rabbitmq_queue_consumers |
| ClusterName,job,namespace,pod,service | rabbitmq_queue_disk_reads_total |
| ClusterName,job,namespace,pod,service | rabbitmq_queue_disk_writes_total |
| ClusterName,job,namespace,pod,service | rabbitmq_queue_index_journal_write_ops_total |
| ClusterName,job,namespace,pod,service | rabbitmq_queue_index_read_ops_total |
| ClusterName,job,namespace,pod,service | rabbitmq_queue_index_write_ops_total |
| ClusterName,job,namespace,pod,service | rabbitmq_queue_messages |
| ClusterName,job,namespace,pod,service | rabbitmq_queue_messages_bytes |
| ClusterName,job,namespace,pod,service | rabbitmq_queue_messages_paged_out |
| ClusterName,job,namespace,pod,service | rabbitmq_queue_messages_paged_out_bytes |
| ClusterName,job,namespace,pod,service | rabbitmq_queue_messages_persistent |
| ClusterName,job,namespace,pod,service | rabbitmq_queue_messages_published_total |
| ClusterName,job,namespace,pod,service | rabbitmq_queue_messages_ram |
| ClusterName,job,namespace,pod,service | rabbitmq_queue_messages_ram_bytes |
| ClusterName,job,namespace,pod,service | rabbitmq_queue_messages_ready |
| ClusterName,job,namespace,pod,service | rabbitmq_queue_messages_ready_bytes |
| ClusterName,job,namespace,pod,service | rabbitmq_queue_messages_ready_ram |
| ClusterName,job,namespace,pod,service | rabbitmq_queue_messages_unacked |
| ClusterName,job,namespace,pod,service | rabbitmq_queue_messages_unacked_bytes |
| ClusterName,job,namespace,pod,service | rabbitmq_queue_messages_unacked_ram |
| ClusterName,job,namespace,pod,service | rabbitmq_queue_process_memory_bytes |
| ClusterName,job,namespace,pod,service | rabbitmq_queue_process_reductions_total |
| ClusterName,job,namespace,pod,service | rabbitmq_queues |
| ClusterName,job,namespace,pod,service | rabbitmq_queues_created_total |
| ClusterName,job,namespace,pod,service | rabbitmq_queues_declared_total |
| ClusterName,job,namespace,pod,service | rabbitmq_queues_deleted_total |
| ClusterName,job,namespace,pod,service | rabbitmq_raft_entry_commit_latency_seconds |
| ClusterName,job,namespace,pod,service | rabbitmq_raft_log_commit_index |
| ClusterName,job,namespace,pod,service | rabbitmq_raft_log_last_applied_index |
| ClusterName,job,namespace,pod,service | rabbitmq_raft_log_last_written_index |
| ClusterName,job,namespace,pod,service | rabbitmq_raft_log_snapshot_index |
| ClusterName,job,namespace,pod,service | rabbitmq_raft_term_total |
| ClusterName,job,namespace,pod,service | rabbitmq_resident_memory_limit_bytes |
| ClusterName,job,namespace,pod,service | rabbitmq_schema_db_disk_tx_total |
| ClusterName,job,namespace,pod,service | rabbitmq_schema_db_ram_tx_total |

<b>sas-rabbitmq</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,alloc,instance_no,job,kind,namespace,pod,service,usage | erlang_vm_allocators |

<b>sas-rabbitmq</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Metric&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; |
| ---------- | ------ |
| ClusterName,job,namespace,peer,pod,service | erlang_vm_dist_node_queue_size_bytes |
| ClusterName,job,namespace,peer,pod,service | erlang_vm_dist_node_state |
| ClusterName,job,namespace,peer,pod,service | erlang_vm_dist_port_input_bytes |
| ClusterName,job,namespace,peer,pod,service | erlang_vm_dist_port_memory_bytes |
| ClusterName,job,namespace,peer,pod,service | erlang_vm_dist_port_output_bytes |
| ClusterName,job,namespace,peer,pod,service | erlang_vm_dist_port_queue_size_bytes |
| ClusterName,job,namespace,peer,pod,service | erlang_vm_dist_recv_avg_bytes |
| ClusterName,job,namespace,peer,pod,service | erlang_vm_dist_recv_bytes |
| ClusterName,job,namespace,peer,pod,service | erlang_vm_dist_recv_cnt |
| ClusterName,job,namespace,peer,pod,service | erlang_vm_dist_recv_dvi_bytes |
| ClusterName,job,namespace,peer,pod,service | erlang_vm_dist_recv_max_bytes |
| ClusterName,job,namespace,peer,pod,service | erlang_vm_dist_send_avg_bytes |
| ClusterName,job,namespace,peer,pod,service | erlang_vm_dist_send_bytes |
| ClusterName,job,namespace,peer,pod,service | erlang_vm_dist_send_cnt |
| ClusterName,job,namespace,peer,pod,service | erlang_vm_dist_send_max_bytes |
| ClusterName,job,namespace,peer,pod,service | erlang_vm_dist_send_pend_bytes |

</details>

## By Metric
lists the dimensions associated with each metric
<details>
  <summary>Click to expand</summary>
<b>cas_node_cpu_time_seconds</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,cas_node,cas_node_type,cas_server,job,namespace,pod,type | sas-cas |
| ClusterName,cas_node,cas_node_type,cas_server,job,namespace,pod,type | sas-cas |
| ClusterName,cas_node,cas_node_type,cas_server,job,namespace,pod,type | sas-cas |

<b>cas_node_fifteen_minute_cpu_load_avg</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,cas_node,cas_node_type,cas_server,job,namespace,pod | sas-cas |
| ClusterName,cas_node,cas_node_type,cas_server,job,namespace,pod | sas-cas |
| ClusterName,cas_node,cas_node_type,cas_server,job,namespace,pod | sas-cas |
| ClusterName,cas_node,cas_node_type,cas_server,job,namespace,pod | sas-cas |
| ClusterName,cas_node,cas_node_type,cas_server,job,namespace,pod | sas-cas |
| ClusterName,cas_node,cas_node_type,cas_server,job,namespace,pod | sas-cas |
| ClusterName,cas_node,cas_node_type,cas_server,job,namespace,pod | sas-cas |
| ClusterName,cas_node,cas_node_type,cas_server,job,namespace,pod | sas-cas |

<b>cas_nodes</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,cas_node,cas_node_type,cas_server,connected,job,namespace,pod,uuid | sas-cas |

<b>cas_grid_idle_seconds</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,cas_server,job,namespace,pod | sas-cas |
| ClusterName,cas_server,job,namespace,pod | sas-cas |
| ClusterName,cas_server,job,namespace,pod | sas-cas |
| ClusterName,cas_server,job,namespace,pod | sas-cas |
| ClusterName,cas_server,job,namespace,pod | sas-cas |
| ClusterName,cas_server,job,namespace,pod | sas-cas |

<b>cas_grid_state</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,cas_server,job,namespace,pod,state | sas-cas |

<b>arke_request_elapsed</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,job,method,namespace,node,pod,quantile,sas_service_base,service,status | sas-go |

<b>sas_db_closed_total</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,job,namespace,node,pod,reason,sas_service_base,schema,service | sas-go |

<b>sas_db_connections_max</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,job,namespace,node,pod,sas_service_base,service,state | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service,state | sas-go |

<b>sas_db_wait_seconds</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,job,namespace,node,pod,sas_service_base,schema,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,schema,service | sas-go |

<b>arke_client_active_messages</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |

<b>sas_db_closed_total</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,job,namespace,node,pod,reason,sas_service_base,service | sas-go |

<b>arke_client_active_messages</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClientIdentitifer,ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClientIdentitifer,ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClientIdentitifer,ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |
| ClientIdentitifer,ClusterName,job,namespace,node,pod,sas_service_base,service | sas-go |

<b>go_gc_duration_seconds</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,job,namespace,node,pod,quantile,sas_service_base,service | sas-go |
| ClusterName,job,namespace,node,pod,quantile,sas_service_base,service | sas-go |

<b>log_events_total</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,job,level,namespace,node,pod,sas_service_base,service | sas-go |

<b>sas_db_connections_max</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,job,namespace,node,pod,sas_service_base,schema,service,state | sas-go |
| ClusterName,job,namespace,node,pod,sas_service_base,schema,service,state | sas-go |

<b>arke_recvmsg_total</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,job,method,namespace,node,pod,sas_service_base,service,status | sas-go |
| ClusterName,job,method,namespace,node,pod,sas_service_base,service,status | sas-go |
| ClusterName,job,method,namespace,node,pod,sas_service_base,service,status | sas-go |
| ClusterName,job,method,namespace,node,pod,sas_service_base,service,status | sas-go |
| ClusterName,job,method,namespace,node,pod,sas_service_base,service,status | sas-go |

<b>jvm_buffer_count_buffers</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,id,job,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,id,job,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,id,job,namespace,node,pod,sas_service_base | sas-java |

<b>spring_rabbitmq_listener_seconds_count</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,job,listener_id,namespace,node,pod,queue,result,sas_service_base | sas-java |
| ClusterName,job,listener_id,namespace,node,pod,queue,result,sas_service_base | sas-java |
| ClusterName,job,listener_id,namespace,node,pod,queue,result,sas_service_base | sas-java |

<b>http_server_requests_seconds_count</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,job,method,namespace,node,outcome,pod,sas_service_base,status,uri | sas-java |
| ClusterName,job,method,namespace,node,outcome,pod,sas_service_base,status,uri | sas-java |
| ClusterName,job,method,namespace,node,outcome,pod,sas_service_base,status,uri | sas-java |

<b>jdbc_connections_active</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,job,name,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,name,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,name,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,name,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,name,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,name,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,name,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,name,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,name,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,name,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,name,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,name,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,name,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,name,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,name,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,name,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,name,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,name,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,name,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,name,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,name,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,name,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,name,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,name,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,name,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,name,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,name,namespace,node,pod,sas_service_base | sas-java |

<b>jvm_classes_loaded_classes</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,job,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,job,namespace,node,pod,sas_service_base | sas-java |

<b>jvm_memory_committed_bytes</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,area,id,job,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,area,id,job,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,area,id,job,namespace,node,pod,sas_service_base | sas-java |

<b>jvm_threads_states_threads</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,job,namespace,node,pod,sas_service_base,state | sas-java |

<b>http_client_requests_seconds_count</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,job,method,namespace,node,pod,sas_service_base,status,uri | sas-java |
| ClusterName,job,method,namespace,node,pod,sas_service_base,status,uri | sas-java |
| ClusterName,job,method,namespace,node,pod,sas_service_base,status,uri | sas-java |

<b>log_events_total</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,job,level,namespace,node,pod,sas_service_base | sas-java |

<b>jvm_gc_pause_seconds_count</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,action,cause,job,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,action,cause,job,namespace,node,pod,sas_service_base | sas-java |
| ClusterName,action,cause,job,namespace,node,pod,sas_service_base | sas-java |

<b>pg_locks_count</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,datname,job,mode,namespace,pod,server,service | sas-postgres |

<b>ccp_backrest_last_info_backup_runtime_seconds</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,backup_type,job,namespace,pod,server,service,stanza | sas-postgres |
| ClusterName,backup_type,job,namespace,pod,server,service,stanza | sas-postgres |
| ClusterName,backup_type,job,namespace,pod,server,service,stanza | sas-postgres |

<b>ccp_stat_user_tables_analyze_count</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,dbname,job,namespace,pod,relname,schemaname,server,service | sas-postgres |
| ClusterName,dbname,job,namespace,pod,relname,schemaname,server,service | sas-postgres |
| ClusterName,dbname,job,namespace,pod,relname,schemaname,server,service | sas-postgres |
| ClusterName,dbname,job,namespace,pod,relname,schemaname,server,service | sas-postgres |
| ClusterName,dbname,job,namespace,pod,relname,schemaname,server,service | sas-postgres |
| ClusterName,dbname,job,namespace,pod,relname,schemaname,server,service | sas-postgres |
| ClusterName,dbname,job,namespace,pod,relname,schemaname,server,service | sas-postgres |
| ClusterName,dbname,job,namespace,pod,relname,schemaname,server,service | sas-postgres |
| ClusterName,dbname,job,namespace,pod,relname,schemaname,server,service | sas-postgres |
| ClusterName,dbname,job,namespace,pod,relname,schemaname,server,service | sas-postgres |
| ClusterName,dbname,job,namespace,pod,relname,schemaname,server,service | sas-postgres |
| ClusterName,dbname,job,namespace,pod,relname,schemaname,server,service | sas-postgres |
| ClusterName,dbname,job,namespace,pod,relname,schemaname,server,service | sas-postgres |
| ClusterName,dbname,job,namespace,pod,relname,schemaname,server,service | sas-postgres |
| ClusterName,dbname,job,namespace,pod,relname,schemaname,server,service | sas-postgres |

<b>ccp_locks_count</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,dbname,job,mode,namespace,pod,server,service | sas-postgres |

<b>ccp_archive_command_status_seconds_since_last_fail</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |
| ClusterName,job,namespace,pod,server,service | sas-postgres |

<b>ccp_data_checksum_failure_time_since_last_failure_seconds</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,dbname,job,namespace,pod,server,service | sas-postgres |
| ClusterName,dbname,job,namespace,pod,server,service | sas-postgres |
| ClusterName,dbname,job,namespace,pod,server,service | sas-postgres |
| ClusterName,dbname,job,namespace,pod,server,service | sas-postgres |
| ClusterName,dbname,job,namespace,pod,server,service | sas-postgres |
| ClusterName,dbname,job,namespace,pod,server,service | sas-postgres |
| ClusterName,dbname,job,namespace,pod,server,service | sas-postgres |
| ClusterName,dbname,job,namespace,pod,server,service | sas-postgres |
| ClusterName,dbname,job,namespace,pod,server,service | sas-postgres |
| ClusterName,dbname,job,namespace,pod,server,service | sas-postgres |
| ClusterName,dbname,job,namespace,pod,server,service | sas-postgres |
| ClusterName,dbname,job,namespace,pod,server,service | sas-postgres |
| ClusterName,dbname,job,namespace,pod,server,service | sas-postgres |
| ClusterName,dbname,job,namespace,pod,server,service | sas-postgres |
| ClusterName,dbname,job,namespace,pod,server,service | sas-postgres |

<b>go_gc_duration_seconds</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,job,namespace,pod,quantile,service | sas-postgres |

<b>ccp_backrest_last_diff_backup_time_since_completion_seconds</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,job,namespace,pod,server,service,stanza | sas-postgres |
| ClusterName,job,namespace,pod,server,service,stanza | sas-postgres |
| ClusterName,job,namespace,pod,server,service,stanza | sas-postgres |

<b>pg_stat_database_blk_read_time</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,datid,datname,job,namespace,pod,server,service | sas-postgres |
| ClusterName,datid,datname,job,namespace,pod,server,service | sas-postgres |
| ClusterName,datid,datname,job,namespace,pod,server,service | sas-postgres |
| ClusterName,datid,datname,job,namespace,pod,server,service | sas-postgres |
| ClusterName,datid,datname,job,namespace,pod,server,service | sas-postgres |
| ClusterName,datid,datname,job,namespace,pod,server,service | sas-postgres |
| ClusterName,datid,datname,job,namespace,pod,server,service | sas-postgres |
| ClusterName,datid,datname,job,namespace,pod,server,service | sas-postgres |
| ClusterName,datid,datname,job,namespace,pod,server,service | sas-postgres |
| ClusterName,datid,datname,job,namespace,pod,server,service | sas-postgres |
| ClusterName,datid,datname,job,namespace,pod,server,service | sas-postgres |
| ClusterName,datid,datname,job,namespace,pod,server,service | sas-postgres |
| ClusterName,datid,datname,job,namespace,pod,server,service | sas-postgres |
| ClusterName,datid,datname,job,namespace,pod,server,service | sas-postgres |
| ClusterName,datid,datname,job,namespace,pod,server,service | sas-postgres |
| ClusterName,datid,datname,job,namespace,pod,server,service | sas-postgres |
| ClusterName,datid,datname,job,namespace,pod,server,service | sas-postgres |
| ClusterName,datid,datname,job,namespace,pod,server,service | sas-postgres |
| ClusterName,datid,datname,job,namespace,pod,server,service | sas-postgres |
| ClusterName,datid,datname,job,namespace,pod,server,service | sas-postgres |
| ClusterName,datid,datname,job,namespace,pod,server,service | sas-postgres |
| ClusterName,datid,datname,job,namespace,pod,server,service | sas-postgres |

<b>ccp_replication_lag_size_bytes</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,job,namespace,pod,replica,replica_port,server,service | sas-postgres |

<b>pg_exporter_user_queries_load_error</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,filename,hashsum,job,namespace,pod,service | sas-postgres |

<b>ccp_nodemx_data_disk_available_bytes</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,fs_type,job,mount_point,namespace,pod,server,service | sas-postgres |
| ClusterName,fs_type,job,mount_point,namespace,pod,server,service | sas-postgres |
| ClusterName,fs_type,job,mount_point,namespace,pod,server,service | sas-postgres |
| ClusterName,fs_type,job,mount_point,namespace,pod,server,service | sas-postgres |

<b>ccp_nodemx_network_rx_bytes</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,interface,job,namespace,pod,server,service | sas-postgres |
| ClusterName,interface,job,namespace,pod,server,service | sas-postgres |
| ClusterName,interface,job,namespace,pod,server,service | sas-postgres |
| ClusterName,interface,job,namespace,pod,server,service | sas-postgres |

<b>ccp_nodemx_disk_activity_sectors_read</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,job,mount_point,namespace,pod,server,service | sas-postgres |
| ClusterName,job,mount_point,namespace,pod,server,service | sas-postgres |

<b>pg_stat_activity_count</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,datname,job,namespace,pod,server,service,state | sas-postgres |
| ClusterName,datname,job,namespace,pod,server,service,state | sas-postgres |

<b>pg_stat_database_blk_read_time</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,datid,job,namespace,pod,server,service | sas-postgres |
| ClusterName,datid,job,namespace,pod,server,service | sas-postgres |
| ClusterName,datid,job,namespace,pod,server,service | sas-postgres |
| ClusterName,datid,job,namespace,pod,server,service | sas-postgres |
| ClusterName,datid,job,namespace,pod,server,service | sas-postgres |
| ClusterName,datid,job,namespace,pod,server,service | sas-postgres |
| ClusterName,datid,job,namespace,pod,server,service | sas-postgres |
| ClusterName,datid,job,namespace,pod,server,service | sas-postgres |
| ClusterName,datid,job,namespace,pod,server,service | sas-postgres |
| ClusterName,datid,job,namespace,pod,server,service | sas-postgres |
| ClusterName,datid,job,namespace,pod,server,service | sas-postgres |
| ClusterName,datid,job,namespace,pod,server,service | sas-postgres |
| ClusterName,datid,job,namespace,pod,server,service | sas-postgres |
| ClusterName,datid,job,namespace,pod,server,service | sas-postgres |
| ClusterName,datid,job,namespace,pod,server,service | sas-postgres |
| ClusterName,datid,job,namespace,pod,server,service | sas-postgres |
| ClusterName,datid,job,namespace,pod,server,service | sas-postgres |

<b>go_gc_duration_seconds_count</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,job,namespace,pod,service | sas-postgres |
| ClusterName,job,namespace,pod,service | sas-postgres |
| ClusterName,job,namespace,pod,service | sas-postgres |
| ClusterName,job,namespace,pod,service | sas-postgres |
| ClusterName,job,namespace,pod,service | sas-postgres |
| ClusterName,job,namespace,pod,service | sas-postgres |
| ClusterName,job,namespace,pod,service | sas-postgres |
| ClusterName,job,namespace,pod,service | sas-postgres |
| ClusterName,job,namespace,pod,service | sas-postgres |
| ClusterName,job,namespace,pod,service | sas-postgres |
| ClusterName,job,namespace,pod,service | sas-postgres |
| ClusterName,job,namespace,pod,service | sas-postgres |
| ClusterName,job,namespace,pod,service | sas-postgres |
| ClusterName,job,namespace,pod,service | sas-postgres |
| ClusterName,job,namespace,pod,service | sas-postgres |
| ClusterName,job,namespace,pod,service | sas-postgres |
| ClusterName,job,namespace,pod,service | sas-postgres |
| ClusterName,job,namespace,pod,service | sas-postgres |
| ClusterName,job,namespace,pod,service | sas-postgres |
| ClusterName,job,namespace,pod,service | sas-postgres |
| ClusterName,job,namespace,pod,service | sas-postgres |
| ClusterName,job,namespace,pod,service | sas-postgres |
| ClusterName,job,namespace,pod,service | sas-postgres |
| ClusterName,job,namespace,pod,service | sas-postgres |
| ClusterName,job,namespace,pod,service | sas-postgres |
| ClusterName,job,namespace,pod,service | sas-postgres |
| ClusterName,job,namespace,pod,service | sas-postgres |
| ClusterName,job,namespace,pod,service | sas-postgres |
| ClusterName,job,namespace,pod,service | sas-postgres |
| ClusterName,job,namespace,pod,service | sas-postgres |
| ClusterName,job,namespace,pod,service | sas-postgres |
| ClusterName,job,namespace,pod,service | sas-postgres |
| ClusterName,job,namespace,pod,service | sas-postgres |
| ClusterName,job,namespace,pod,service | sas-postgres |
| ClusterName,job,namespace,pod,service | sas-postgres |
| ClusterName,job,namespace,pod,service | sas-postgres |
| ClusterName,job,namespace,pod,service | sas-postgres |
| ClusterName,job,namespace,pod,service | sas-postgres |
| ClusterName,job,namespace,pod,service | sas-postgres |

<b>pg_static</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,job,namespace,pod,server,service,short_version,version | sas-postgres |

<b>erlang_vm_dist_proc_heap_size_words</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,job,namespace,peer,pod,service,type | sas-rabbitmq |
| ClusterName,job,namespace,peer,pod,service,type | sas-rabbitmq |
| ClusterName,job,namespace,peer,pod,service,type | sas-rabbitmq |
| ClusterName,job,namespace,peer,pod,service,type | sas-rabbitmq |
| ClusterName,job,namespace,peer,pod,service,type | sas-rabbitmq |
| ClusterName,job,namespace,peer,pod,service,type | sas-rabbitmq |
| ClusterName,job,namespace,peer,pod,service,type | sas-rabbitmq |
| ClusterName,job,namespace,peer,pod,service,type | sas-rabbitmq |
| ClusterName,job,namespace,peer,pod,service,type | sas-rabbitmq |

<b>telemetry_scrape_encoded_size_bytes_count</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,content_type,encoding,job,namespace,pod,registry,service | sas-rabbitmq |
| ClusterName,content_type,encoding,job,namespace,pod,registry,service | sas-rabbitmq |

<b>erlang_vm_msacc_alloc_seconds_total</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,id,job,namespace,pod,service,type | sas-rabbitmq |
| ClusterName,id,job,namespace,pod,service,type | sas-rabbitmq |
| ClusterName,id,job,namespace,pod,service,type | sas-rabbitmq |
| ClusterName,id,job,namespace,pod,service,type | sas-rabbitmq |
| ClusterName,id,job,namespace,pod,service,type | sas-rabbitmq |
| ClusterName,id,job,namespace,pod,service,type | sas-rabbitmq |
| ClusterName,id,job,namespace,pod,service,type | sas-rabbitmq |
| ClusterName,id,job,namespace,pod,service,type | sas-rabbitmq |
| ClusterName,id,job,namespace,pod,service,type | sas-rabbitmq |
| ClusterName,id,job,namespace,pod,service,type | sas-rabbitmq |
| ClusterName,id,job,namespace,pod,service,type | sas-rabbitmq |
| ClusterName,id,job,namespace,pod,service,type | sas-rabbitmq |
| ClusterName,id,job,namespace,pod,service,type | sas-rabbitmq |
| ClusterName,id,job,namespace,pod,service,type | sas-rabbitmq |
| ClusterName,id,job,namespace,pod,service,type | sas-rabbitmq |

<b>telemetry_scrape_duration_seconds_count</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,content_type,job,namespace,pod,registry,service | sas-rabbitmq |
| ClusterName,content_type,job,namespace,pod,registry,service | sas-rabbitmq |
| ClusterName,content_type,job,namespace,pod,registry,service | sas-rabbitmq |
| ClusterName,content_type,job,namespace,pod,registry,service | sas-rabbitmq |

<b>erlang_vm_memory_atom_bytes_total</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,job,namespace,pod,service,usage | sas-rabbitmq |
| ClusterName,job,namespace,pod,service,usage | sas-rabbitmq |
| ClusterName,job,namespace,pod,service,usage | sas-rabbitmq |

<b>erlang_vm_memory_bytes_total</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,job,kind,namespace,pod,service | sas-rabbitmq |

<b>rabbitmq_auth_attempts_failed_total</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,job,namespace,pod,protocol,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,protocol,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,protocol,service | sas-rabbitmq |

<b>erlang_mnesia_committed_transactions</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,pod,service | sas-rabbitmq |

<b>erlang_vm_allocators</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,alloc,instance_no,job,kind,namespace,pod,service,usage | sas-rabbitmq |

<b>erlang_vm_dist_node_queue_size_bytes</b>

| Dimensions&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Source |
| ---------- | ------ |
| ClusterName,job,namespace,peer,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,peer,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,peer,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,peer,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,peer,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,peer,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,peer,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,peer,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,peer,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,peer,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,peer,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,peer,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,peer,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,peer,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,peer,pod,service | sas-rabbitmq |
| ClusterName,job,namespace,peer,pod,service | sas-rabbitmq |

</details>
