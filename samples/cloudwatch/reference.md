# CloudWatch SAS Viya Platform Metrics

## By Dimensions
This table lists the metrics associated with each set of dimensions.
<details>
  <summary>Dimensions</summary>
<hr/>
<details>
  <summary>ClusterName,cas_node,cas_node_type,cas_server,connected,job,namespace,pod,uuid (1)</summary>

| Metric | Source |
| ------ | ------ |
| cas_nodes | CAS |

</details>
<hr/>
<details>
  <summary>ClusterName,cas_server,job,namespace,pod (6)</summary>

| Metric | Source |
| ------ | ------ |
| cas_grid_idle_seconds | CAS |
| cas_grid_sessions_created_total | CAS |
| cas_grid_sessions_current | CAS |
| cas_grid_sessions_max | CAS |
| cas_grid_start_time_seconds | CAS |
| cas_grid_uptime_seconds_total | CAS |

</details>
<hr/>
<details>
  <summary>ClusterName,cas_server,job,namespace,pod,state (1)</summary>

| Metric | Source |
| ------ | ------ |
| cas_grid_state | CAS |

</details>
<hr/>
<details>
  <summary>ClusterName,cas_node,cas_node_type,cas_server,job,namespace,pod,type (3)</summary>

| Metric | Source |
| ------ | ------ |
| cas_node_cpu_time_seconds | CAS |
| cas_node_mem_free_bytes | CAS |
| cas_node_mem_size_bytes | CAS |

</details>
<hr/>
<details>
  <summary>ClusterName,cas_node,cas_node_type,cas_server,job,namespace,pod (8)</summary>

| Metric | Source |
| ------ | ------ |
| cas_node_fifteen_minute_cpu_load_avg | CAS |
| cas_node_five_minute_cpu_load_avg | CAS |
| cas_node_free_files | CAS |
| cas_node_inodes_free | CAS |
| cas_node_inodes_used | CAS |
| cas_node_max_open_files | CAS |
| cas_node_one_minute_cpu_load_avg | CAS |
| cas_node_open_files | CAS |

</details>
<hr/>
<details>
  <summary>ClusterName,job,namespace,node,pod,quantile,sas_service_base,service (1)</summary>

| Metric | Source |
| ------ | ------ |
| go_gc_duration_seconds | SAS Go Microservices |

</details>
<hr/>
<details>
  <summary>ClusterName,job,namespace,node,pod,sas_service_base,service,state (2)</summary>

| Metric | Source |
| ------ | ------ |
| sas_db_connections_max | SAS Go Microservices |
| sas_db_pool_connections | SAS Go Microservices |

</details>
<hr/>
<details>
  <summary>ClusterName,job,method,namespace,node,pod,quantile,sas_service_base,service,status (1)</summary>

| Metric | Source |
| ------ | ------ |
| arke_request_elapsed | SAS Go Microservices |

</details>
<hr/>
<details>
  <summary>ClusterName,job,namespace,node,pod,sas_service_base,schema,service,state (2)</summary>

| Metric | Source |
| ------ | ------ |
| sas_db_connections_max | SAS Go Microservices |
| sas_db_pool_connections | SAS Go Microservices |

</details>
<hr/>
<details>
  <summary>ClusterName,job,namespace,node,pod,reason,sas_service_base,service (1)</summary>

| Metric | Source |
| ------ | ------ |
| sas_db_closed_total | SAS Go Microservices |

</details>
<hr/>
<details>
  <summary>ClusterName,job,namespace,node,pod,sas_service_base,schema,service (2)</summary>

| Metric | Source |
| ------ | ------ |
| sas_db_wait_seconds | SAS Go Microservices |
| sas_db_wait_total | SAS Go Microservices |

</details>
<hr/>
<details>
  <summary>ClientIdentitifer,ClusterName,job,namespace,node,pod,sas_service_base,service (4)</summary>

| Metric | Source |
| ------ | ------ |
| arke_client_active_messages | SAS Go Microservices |
| arke_client_consumed_total | SAS Go Microservices |
| arke_client_produced_total | SAS Go Microservices |
| arke_client_streams | SAS Go Microservices |

</details>
<hr/>
<details>
  <summary>ClusterName,job,namespace,node,pod,sas_service_base,service (61)</summary>

| Metric | Source |
| ------ | ------ |
| arke_client_active_messages | SAS Go Microservices |
| arke_client_consumed_total | SAS Go Microservices |
| arke_client_produced_total | SAS Go Microservices |
| arke_client_streams | SAS Go Microservices |
| arke_recvmsg_total | SAS Go Microservices |
| arke_request_elapsed_count | SAS Go Microservices |
| arke_request_elapsed_sum | SAS Go Microservices |
| arke_request_total | SAS Go Microservices |
| arke_sendmsg_total | SAS Go Microservices |
| go_gc_duration_seconds_count | SAS Go Microservices |
| go_gc_duration_seconds_sum | SAS Go Microservices |
| go_goroutines | SAS Go Microservices |
| go_memstats_alloc_bytes | SAS Go Microservices |
| go_memstats_alloc_bytes_total | SAS Go Microservices |
| go_memstats_buck_hash_sys_bytes | SAS Go Microservices |
| go_memstats_frees_total | SAS Go Microservices |
| go_memstats_gc_cpu_fraction | SAS Go Microservices |
| go_memstats_gc_sys_bytes | SAS Go Microservices |
| go_memstats_heap_alloc_bytes | SAS Go Microservices |
| go_memstats_heap_idle_bytes | SAS Go Microservices |
| go_memstats_heap_inuse_bytes | SAS Go Microservices |
| go_memstats_heap_objects | SAS Go Microservices |
| go_memstats_heap_released_bytes | SAS Go Microservices |
| go_memstats_heap_sys_bytes | SAS Go Microservices |
| go_memstats_last_gc_time_seconds | SAS Go Microservices |
| go_memstats_lookups_total | SAS Go Microservices |
| go_memstats_mallocs_total | SAS Go Microservices |
| go_memstats_mcache_inuse_bytes | SAS Go Microservices |
| go_memstats_mcache_sys_bytes | SAS Go Microservices |
| go_memstats_mspan_inuse_bytes | SAS Go Microservices |
| go_memstats_mspan_sys_bytes | SAS Go Microservices |
| go_memstats_next_gc_bytes | SAS Go Microservices |
| go_memstats_other_sys_bytes | SAS Go Microservices |
| go_memstats_stack_inuse_bytes | SAS Go Microservices |
| go_memstats_stack_sys_bytes | SAS Go Microservices |
| go_memstats_sys_bytes | SAS Go Microservices |
| go_threads | SAS Go Microservices |
| process_cpu_seconds_total | SAS Go Microservices |
| process_max_fds | SAS Go Microservices |
| process_open_fds | SAS Go Microservices |
| process_resident_memory_bytes | SAS Go Microservices |
| process_start_time_seconds | SAS Go Microservices |
| process_virtual_memory_bytes | SAS Go Microservices |
| process_virtual_memory_max_bytes | SAS Go Microservices |
| runtime_alloc_bytes | SAS Go Microservices |
| runtime_free_count | SAS Go Microservices |
| runtime_gc_pause_ns_count | SAS Go Microservices |
| runtime_gc_pause_ns_sum | SAS Go Microservices |
| runtime_heap_objects | SAS Go Microservices |
| runtime_malloc_count | SAS Go Microservices |
| runtime_num_goroutines | SAS Go Microservices |
| runtime_sys_bytes | SAS Go Microservices |
| runtime_total_gc_pause_ns | SAS Go Microservices |
| runtime_total_gc_runs | SAS Go Microservices |
| sas_db_wait_seconds | SAS Go Microservices |
| sas_db_wait_total | SAS Go Microservices |
| sas_maps_esri_query_duration_seconds_count | SAS Go Microservices |
| sas_maps_esri_query_duration_seconds_sum | SAS Go Microservices |
| sas_maps_report_polling_attempts_total | SAS Go Microservices |
| sas_maps_report_query_duration_seconds_count | SAS Go Microservices |
| sas_maps_report_query_duration_seconds_sum | SAS Go Microservices |

</details>
<hr/>
<details>
  <summary>ClusterName,job,method,namespace,node,pod,sas_service_base,service,status (5)</summary>

| Metric | Source |
| ------ | ------ |
| arke_recvmsg_total | SAS Go Microservices |
| arke_request_elapsed_count | SAS Go Microservices |
| arke_request_elapsed_sum | SAS Go Microservices |
| arke_request_total | SAS Go Microservices |
| arke_sendmsg_total | SAS Go Microservices |

</details>
<hr/>
<details>
  <summary>ClusterName,job,level,namespace,node,pod,sas_service_base,service (1)</summary>

| Metric | Source |
| ------ | ------ |
| log_events_total | SAS Go Microservices |

</details>
<hr/>
<details>
  <summary>ClusterName,job,namespace,node,pod,reason,sas_service_base,schema,service (1)</summary>

| Metric | Source |
| ------ | ------ |
| sas_db_closed_total | SAS Go Microservices |

</details>
<hr/>
<details>
  <summary>ClusterName,job,method,namespace,node,outcome,pod,sas_service_base,status,uri (3)</summary>

| Metric | Source |
| ------ | ------ |
| http_server_requests_seconds_count | SAS Java Microservices |
| http_server_requests_seconds_max | SAS Java Microservices |
| http_server_requests_seconds_sum | SAS Java Microservices |

</details>
<hr/>
<details>
  <summary>ClusterName,job,level,namespace,node,pod,sas_service_base (1)</summary>

| Metric | Source |
| ------ | ------ |
| log_events_total | SAS Java Microservices |

</details>
<hr/>
<details>
  <summary>ClusterName,id,job,namespace,node,pod,sas_service_base (3)</summary>

| Metric | Source |
| ------ | ------ |
| jvm_buffer_count_buffers | SAS Java Microservices |
| jvm_buffer_memory_used_bytes | SAS Java Microservices |
| jvm_buffer_total_capacity_bytes | SAS Java Microservices |

</details>
<hr/>
<details>
  <summary>ClusterName,action,cause,job,namespace,node,pod,sas_service_base (3)</summary>

| Metric | Source |
| ------ | ------ |
| jvm_gc_pause_seconds_count | SAS Java Microservices |
| jvm_gc_pause_seconds_max | SAS Java Microservices |
| jvm_gc_pause_seconds_sum | SAS Java Microservices |

</details>
<hr/>
<details>
  <summary>ClusterName,job,listener_id,namespace,node,pod,queue,result,sas_service_base (3)</summary>

| Metric | Source |
| ------ | ------ |
| spring_rabbitmq_listener_seconds_count | SAS Java Microservices |
| spring_rabbitmq_listener_seconds_max | SAS Java Microservices |
| spring_rabbitmq_listener_seconds_sum | SAS Java Microservices |

</details>
<hr/>
<details>
  <summary>ClusterName,job,method,namespace,node,pod,sas_service_base,status,uri (3)</summary>

| Metric | Source |
| ------ | ------ |
| http_client_requests_seconds_count | SAS Java Microservices |
| http_client_requests_seconds_max | SAS Java Microservices |
| http_client_requests_seconds_sum | SAS Java Microservices |

</details>
<hr/>
<details>
  <summary>ClusterName,area,id,job,namespace,node,pod,sas_service_base (3)</summary>

| Metric | Source |
| ------ | ------ |
| jvm_memory_committed_bytes | SAS Java Microservices |
| jvm_memory_max_bytes | SAS Java Microservices |
| jvm_memory_used_bytes | SAS Java Microservices |

</details>
<hr/>
<details>
  <summary>ClusterName,job,namespace,node,pod,sas_service_base,state (1)</summary>

| Metric | Source |
| ------ | ------ |
| jvm_threads_states_threads | SAS Java Microservices |

</details>
<hr/>
<details>
  <summary>ClusterName,job,name,namespace,node,pod,sas_service_base (27)</summary>

| Metric | Source |
| ------ | ------ |
| jdbc_connections_active | SAS Java Microservices |
| jdbc_connections_idle | SAS Java Microservices |
| jdbc_connections_max | SAS Java Microservices |
| jdbc_connections_min | SAS Java Microservices |
| rabbitmq_acknowledged_published_total | SAS Java Microservices |
| rabbitmq_acknowledged_total | SAS Java Microservices |
| rabbitmq_channels | SAS Java Microservices |
| rabbitmq_connections | SAS Java Microservices |
| rabbitmq_consumed_total | SAS Java Microservices |
| rabbitmq_failed_to_publish_total | SAS Java Microservices |
| rabbitmq_not_acknowledged_published_total | SAS Java Microservices |
| rabbitmq_published_total | SAS Java Microservices |
| rabbitmq_rejected_total | SAS Java Microservices |
| rabbitmq_unrouted_published_total | SAS Java Microservices |
| tomcat_global_error_total | SAS Java Microservices |
| tomcat_global_received_bytes_total | SAS Java Microservices |
| tomcat_global_request_max_seconds | SAS Java Microservices |
| tomcat_global_request_seconds_count | SAS Java Microservices |
| tomcat_global_request_seconds_sum | SAS Java Microservices |
| tomcat_global_sent_bytes_total | SAS Java Microservices |
| tomcat_servlet_error_total | SAS Java Microservices |
| tomcat_servlet_request_max_seconds | SAS Java Microservices |
| tomcat_servlet_request_seconds_count | SAS Java Microservices |
| tomcat_servlet_request_seconds_sum | SAS Java Microservices |
| tomcat_threads_busy_threads | SAS Java Microservices |
| tomcat_threads_config_max_threads | SAS Java Microservices |
| tomcat_threads_current_threads | SAS Java Microservices |

</details>
<hr/>
<details>
  <summary>ClusterName,job,namespace,node,pod,sas_service_base (35)</summary>

| Metric | Source |
| ------ | ------ |
| jvm_classes_loaded_classes | SAS Java Microservices |
| jvm_classes_unloaded_classes_total | SAS Java Microservices |
| jvm_gc_live_data_size_bytes | SAS Java Microservices |
| jvm_gc_max_data_size_bytes | SAS Java Microservices |
| jvm_gc_memory_allocated_bytes_total | SAS Java Microservices |
| jvm_gc_memory_promoted_bytes_total | SAS Java Microservices |
| jvm_threads_daemon_threads | SAS Java Microservices |
| jvm_threads_live_threads | SAS Java Microservices |
| jvm_threads_peak_threads | SAS Java Microservices |
| process_cpu_usage | SAS Java Microservices |
| process_files_max_files | SAS Java Microservices |
| process_files_open_files | SAS Java Microservices |
| process_start_time_seconds | SAS Java Microservices |
| process_uptime_seconds | SAS Java Microservices |
| spring_integration_channels | SAS Java Microservices |
| spring_integration_handlers | SAS Java Microservices |
| spring_integration_sources | SAS Java Microservices |
| system_cpu_count | SAS Java Microservices |
| system_cpu_usage | SAS Java Microservices |
| system_load_average_1m | SAS Java Microservices |
| tomcat_cache_access_total | SAS Java Microservices |
| tomcat_cache_hit_total | SAS Java Microservices |
| tomcat_sessions_active_current_sessions | SAS Java Microservices |
| tomcat_sessions_active_max_sessions | SAS Java Microservices |
| tomcat_sessions_alive_max_seconds | SAS Java Microservices |
| tomcat_sessions_created_sessions_total | SAS Java Microservices |
| tomcat_sessions_expired_sessions_total | SAS Java Microservices |
| tomcat_sessions_rejected_sessions_total | SAS Java Microservices |
| zipkin_reporter_messages_bytes_total | SAS Java Microservices |
| zipkin_reporter_messages_total | SAS Java Microservices |
| zipkin_reporter_queue_bytes | SAS Java Microservices |
| zipkin_reporter_queue_spans | SAS Java Microservices |
| zipkin_reporter_spans_bytes_total | SAS Java Microservices |
| zipkin_reporter_spans_dropped_total | SAS Java Microservices |
| zipkin_reporter_spans_total | SAS Java Microservices |

</details>
<hr/>
<details>
  <summary>ClusterName,filename,hashsum,job,namespace,pod,service (1)</summary>

| Metric | Source |
| ------ | ------ |
| pg_exporter_user_queries_load_error | Postgres |

</details>
<hr/>
<details>
  <summary>ClusterName,job,namespace,pod,server,service (300)</summary>

| Metric | Source |
| ------ | ------ |
| ccp_archive_command_status_seconds_since_last_fail | Postgres |
| ccp_connection_stats_active | Postgres |
| ccp_connection_stats_idle | Postgres |
| ccp_connection_stats_idle_in_txn | Postgres |
| ccp_connection_stats_max_blocked_query_time | Postgres |
| ccp_connection_stats_max_connections | Postgres |
| ccp_connection_stats_max_idle_in_txn_time | Postgres |
| ccp_connection_stats_max_query_time | Postgres |
| ccp_connection_stats_total | Postgres |
| ccp_data_checksum_failure_time_since_last_failure_seconds | Postgres |
| ccp_is_in_recovery_status | Postgres |
| ccp_nodemx_cpu_limit | Postgres |
| ccp_nodemx_cpu_request | Postgres |
| ccp_nodemx_cpuacct_usage | Postgres |
| ccp_nodemx_cpucfs_period_us | Postgres |
| ccp_nodemx_cpucfs_quota_us | Postgres |
| ccp_nodemx_cpustat_nr_periods | Postgres |
| ccp_nodemx_cpustat_nr_throttled | Postgres |
| ccp_nodemx_cpustat_throttled_time | Postgres |
| ccp_nodemx_mem_active_anon | Postgres |
| ccp_nodemx_mem_active_file | Postgres |
| ccp_nodemx_mem_cache | Postgres |
| ccp_nodemx_mem_inactive_anon | Postgres |
| ccp_nodemx_mem_inactive_file | Postgres |
| ccp_nodemx_mem_limit | Postgres |
| ccp_nodemx_mem_mapped_file | Postgres |
| ccp_nodemx_mem_request | Postgres |
| ccp_nodemx_mem_rss | Postgres |
| ccp_nodemx_process_count | Postgres |
| ccp_pg_hba_checksum_status | Postgres |
| ccp_pg_settings_checksum_status | Postgres |
| ccp_postgresql_version_current | Postgres |
| ccp_postmaster_runtime_start_time_seconds | Postgres |
| ccp_postmaster_uptime_seconds | Postgres |
| ccp_sequence_exhaustion_count | Postgres |
| ccp_settings_gauge_checkpoint_completion_target | Postgres |
| ccp_settings_gauge_checkpoint_timeout | Postgres |
| ccp_settings_gauge_shared_buffers | Postgres |
| ccp_settings_pending_restart_count | Postgres |
| ccp_stat_bgwriter_buffers_alloc | Postgres |
| ccp_stat_bgwriter_buffers_backend | Postgres |
| ccp_stat_bgwriter_buffers_backend_fsync | Postgres |
| ccp_stat_bgwriter_buffers_checkpoint | Postgres |
| ccp_stat_bgwriter_buffers_clean | Postgres |
| ccp_stat_bgwriter_checkpoint_sync_time | Postgres |
| ccp_stat_bgwriter_checkpoint_write_time | Postgres |
| ccp_stat_bgwriter_checkpoints_req | Postgres |
| ccp_stat_bgwriter_checkpoints_timed | Postgres |
| ccp_stat_bgwriter_maxwritten_clean | Postgres |
| ccp_stat_bgwriter_stats_reset | Postgres |
| ccp_transaction_wraparound_oldest_current_xid | Postgres |
| ccp_transaction_wraparound_percent_towards_emergency_autovac | Postgres |
| ccp_transaction_wraparound_percent_towards_wraparound | Postgres |
| ccp_wal_activity_last_5_min_size_bytes | Postgres |
| ccp_wal_activity_total_size_bytes | Postgres |
| pg_settings_allow_system_table_mods | Postgres |
| pg_settings_archive_timeout_seconds | Postgres |
| pg_settings_array_nulls | Postgres |
| pg_settings_authentication_timeout_seconds | Postgres |
| pg_settings_autovacuum | Postgres |
| pg_settings_autovacuum_analyze_scale_factor | Postgres |
| pg_settings_autovacuum_analyze_threshold | Postgres |
| pg_settings_autovacuum_freeze_max_age | Postgres |
| pg_settings_autovacuum_max_workers | Postgres |
| pg_settings_autovacuum_multixact_freeze_max_age | Postgres |
| pg_settings_autovacuum_naptime_seconds | Postgres |
| pg_settings_autovacuum_vacuum_cost_delay_seconds | Postgres |
| pg_settings_autovacuum_vacuum_cost_limit | Postgres |
| pg_settings_autovacuum_vacuum_scale_factor | Postgres |
| pg_settings_autovacuum_vacuum_threshold | Postgres |
| pg_settings_autovacuum_work_mem_bytes | Postgres |
| pg_settings_backend_flush_after_bytes | Postgres |
| pg_settings_bgwriter_delay_seconds | Postgres |
| pg_settings_bgwriter_flush_after_bytes | Postgres |
| pg_settings_bgwriter_lru_maxpages | Postgres |
| pg_settings_bgwriter_lru_multiplier | Postgres |
| pg_settings_block_size | Postgres |
| pg_settings_bonjour | Postgres |
| pg_settings_check_function_bodies | Postgres |
| pg_settings_checkpoint_completion_target | Postgres |
| pg_settings_checkpoint_flush_after_bytes | Postgres |
| pg_settings_checkpoint_timeout_seconds | Postgres |
| pg_settings_checkpoint_warning_seconds | Postgres |
| pg_settings_commit_delay | Postgres |
| pg_settings_commit_siblings | Postgres |
| pg_settings_cpu_index_tuple_cost | Postgres |
| pg_settings_cpu_operator_cost | Postgres |
| pg_settings_cpu_tuple_cost | Postgres |
| pg_settings_cursor_tuple_fraction | Postgres |
| pg_settings_data_checksums | Postgres |
| pg_settings_data_directory_mode | Postgres |
| pg_settings_data_sync_retry | Postgres |
| pg_settings_db_user_namespace | Postgres |
| pg_settings_deadlock_timeout_seconds | Postgres |
| pg_settings_debug_assertions | Postgres |
| pg_settings_debug_pretty_print | Postgres |
| pg_settings_debug_print_parse | Postgres |
| pg_settings_debug_print_plan | Postgres |
| pg_settings_debug_print_rewritten | Postgres |
| pg_settings_default_statistics_target | Postgres |
| pg_settings_default_transaction_deferrable | Postgres |
| pg_settings_default_transaction_read_only | Postgres |
| pg_settings_effective_cache_size_bytes | Postgres |
| pg_settings_effective_io_concurrency | Postgres |
| pg_settings_enable_bitmapscan | Postgres |
| pg_settings_enable_gathermerge | Postgres |
| pg_settings_enable_hashagg | Postgres |
| pg_settings_enable_hashjoin | Postgres |
| pg_settings_enable_indexonlyscan | Postgres |
| pg_settings_enable_indexscan | Postgres |
| pg_settings_enable_material | Postgres |
| pg_settings_enable_mergejoin | Postgres |
| pg_settings_enable_nestloop | Postgres |
| pg_settings_enable_parallel_append | Postgres |
| pg_settings_enable_parallel_hash | Postgres |
| pg_settings_enable_partition_pruning | Postgres |
| pg_settings_enable_partitionwise_aggregate | Postgres |
| pg_settings_enable_partitionwise_join | Postgres |
| pg_settings_enable_seqscan | Postgres |
| pg_settings_enable_sort | Postgres |
| pg_settings_enable_tidscan | Postgres |
| pg_settings_escape_string_warning | Postgres |
| pg_settings_exit_on_error | Postgres |
| pg_settings_extra_float_digits | Postgres |
| pg_settings_from_collapse_limit | Postgres |
| pg_settings_fsync | Postgres |
| pg_settings_full_page_writes | Postgres |
| pg_settings_geqo | Postgres |
| pg_settings_geqo_effort | Postgres |
| pg_settings_geqo_generations | Postgres |
| pg_settings_geqo_pool_size | Postgres |
| pg_settings_geqo_seed | Postgres |
| pg_settings_geqo_selection_bias | Postgres |
| pg_settings_geqo_threshold | Postgres |
| pg_settings_gin_fuzzy_search_limit | Postgres |
| pg_settings_gin_pending_list_limit_bytes | Postgres |
| pg_settings_hot_standby | Postgres |
| pg_settings_hot_standby_feedback | Postgres |
| pg_settings_idle_in_transaction_session_timeout_seconds | Postgres |
| pg_settings_ignore_checksum_failure | Postgres |
| pg_settings_ignore_system_indexes | Postgres |
| pg_settings_integer_datetimes | Postgres |
| pg_settings_jit | Postgres |
| pg_settings_jit_above_cost | Postgres |
| pg_settings_jit_debugging_support | Postgres |
| pg_settings_jit_dump_bitcode | Postgres |
| pg_settings_jit_expressions | Postgres |
| pg_settings_jit_inline_above_cost | Postgres |
| pg_settings_jit_optimize_above_cost | Postgres |
| pg_settings_jit_profiling_support | Postgres |
| pg_settings_jit_tuple_deforming | Postgres |
| pg_settings_join_collapse_limit | Postgres |
| pg_settings_krb_caseins_users | Postgres |
| pg_settings_lo_compat_privileges | Postgres |
| pg_settings_lock_timeout_seconds | Postgres |
| pg_settings_log_autovacuum_min_duration_seconds | Postgres |
| pg_settings_log_checkpoints | Postgres |
| pg_settings_log_connections | Postgres |
| pg_settings_log_disconnections | Postgres |
| pg_settings_log_duration | Postgres |
| pg_settings_log_executor_stats | Postgres |
| pg_settings_log_file_mode | Postgres |
| pg_settings_log_hostname | Postgres |
| pg_settings_log_lock_waits | Postgres |
| pg_settings_log_min_duration_statement_seconds | Postgres |
| pg_settings_log_parser_stats | Postgres |
| pg_settings_log_planner_stats | Postgres |
| pg_settings_log_replication_commands | Postgres |
| pg_settings_log_rotation_age_seconds | Postgres |
| pg_settings_log_rotation_size_bytes | Postgres |
| pg_settings_log_statement_stats | Postgres |
| pg_settings_log_temp_files_bytes | Postgres |
| pg_settings_log_transaction_sample_rate | Postgres |
| pg_settings_log_truncate_on_rotation | Postgres |
| pg_settings_logging_collector | Postgres |
| pg_settings_maintenance_work_mem_bytes | Postgres |
| pg_settings_max_connections | Postgres |
| pg_settings_max_files_per_process | Postgres |
| pg_settings_max_function_args | Postgres |
| pg_settings_max_identifier_length | Postgres |
| pg_settings_max_index_keys | Postgres |
| pg_settings_max_locks_per_transaction | Postgres |
| pg_settings_max_logical_replication_workers | Postgres |
| pg_settings_max_parallel_maintenance_workers | Postgres |
| pg_settings_max_parallel_workers | Postgres |
| pg_settings_max_parallel_workers_per_gather | Postgres |
| pg_settings_max_pred_locks_per_page | Postgres |
| pg_settings_max_pred_locks_per_relation | Postgres |
| pg_settings_max_pred_locks_per_transaction | Postgres |
| pg_settings_max_prepared_transactions | Postgres |
| pg_settings_max_replication_slots | Postgres |
| pg_settings_max_stack_depth_bytes | Postgres |
| pg_settings_max_standby_archive_delay_seconds | Postgres |
| pg_settings_max_standby_streaming_delay_seconds | Postgres |
| pg_settings_max_sync_workers_per_subscription | Postgres |
| pg_settings_max_wal_senders | Postgres |
| pg_settings_max_wal_size_bytes | Postgres |
| pg_settings_max_worker_processes | Postgres |
| pg_settings_min_parallel_index_scan_size_bytes | Postgres |
| pg_settings_min_parallel_table_scan_size_bytes | Postgres |
| pg_settings_min_wal_size_bytes | Postgres |
| pg_settings_old_snapshot_threshold_seconds | Postgres |
| pg_settings_operator_precedence_warning | Postgres |
| pg_settings_parallel_leader_participation | Postgres |
| pg_settings_parallel_setup_cost | Postgres |
| pg_settings_parallel_tuple_cost | Postgres |
| pg_settings_pg_stat_statements_max | Postgres |
| pg_settings_pg_stat_statements_save | Postgres |
| pg_settings_pg_stat_statements_track_utility | Postgres |
| pg_settings_pgaudit_log_catalog | Postgres |
| pg_settings_pgaudit_log_client | Postgres |
| pg_settings_pgaudit_log_parameter | Postgres |
| pg_settings_pgaudit_log_relation | Postgres |
| pg_settings_pgaudit_log_statement_once | Postgres |
| pg_settings_pgnodemx_cgroup_enabled | Postgres |
| pg_settings_pgnodemx_containerized | Postgres |
| pg_settings_pgnodemx_kdapi_enabled | Postgres |
| pg_settings_plpgsql_check_asserts | Postgres |
| pg_settings_plpgsql_print_strict_params | Postgres |
| pg_settings_port | Postgres |
| pg_settings_post_auth_delay_seconds | Postgres |
| pg_settings_pre_auth_delay_seconds | Postgres |
| pg_settings_quote_all_identifiers | Postgres |
| pg_settings_random_page_cost | Postgres |
| pg_settings_recovery_min_apply_delay_seconds | Postgres |
| pg_settings_recovery_target_inclusive | Postgres |
| pg_settings_restart_after_crash | Postgres |
| pg_settings_row_security | Postgres |
| pg_settings_segment_size_bytes | Postgres |
| pg_settings_seq_page_cost | Postgres |
| pg_settings_server_version_num | Postgres |
| pg_settings_shared_buffers_bytes | Postgres |
| pg_settings_ssl | Postgres |
| pg_settings_ssl_passphrase_command_supports_reload | Postgres |
| pg_settings_ssl_prefer_server_ciphers | Postgres |
| pg_settings_standard_conforming_strings | Postgres |
| pg_settings_statement_timeout_seconds | Postgres |
| pg_settings_superuser_reserved_connections | Postgres |
| pg_settings_synchronize_seqscans | Postgres |
| pg_settings_syslog_sequence_numbers | Postgres |
| pg_settings_syslog_split_messages | Postgres |
| pg_settings_tcp_keepalives_count | Postgres |
| pg_settings_tcp_keepalives_idle_seconds | Postgres |
| pg_settings_tcp_keepalives_interval_seconds | Postgres |
| pg_settings_tcp_user_timeout_seconds | Postgres |
| pg_settings_temp_buffers_bytes | Postgres |
| pg_settings_temp_file_limit_bytes | Postgres |
| pg_settings_trace_notify | Postgres |
| pg_settings_trace_sort | Postgres |
| pg_settings_track_activities | Postgres |
| pg_settings_track_activity_query_size_bytes | Postgres |
| pg_settings_track_commit_timestamp | Postgres |
| pg_settings_track_counts | Postgres |
| pg_settings_track_io_timing | Postgres |
| pg_settings_transaction_deferrable | Postgres |
| pg_settings_transaction_read_only | Postgres |
| pg_settings_transform_null_equals | Postgres |
| pg_settings_unix_socket_permissions | Postgres |
| pg_settings_update_process_title | Postgres |
| pg_settings_vacuum_cleanup_index_scale_factor | Postgres |
| pg_settings_vacuum_cost_delay_seconds | Postgres |
| pg_settings_vacuum_cost_limit | Postgres |
| pg_settings_vacuum_cost_page_dirty | Postgres |
| pg_settings_vacuum_cost_page_hit | Postgres |
| pg_settings_vacuum_cost_page_miss | Postgres |
| pg_settings_vacuum_defer_cleanup_age | Postgres |
| pg_settings_vacuum_freeze_min_age | Postgres |
| pg_settings_vacuum_freeze_table_age | Postgres |
| pg_settings_vacuum_multixact_freeze_min_age | Postgres |
| pg_settings_vacuum_multixact_freeze_table_age | Postgres |
| pg_settings_wal_block_size | Postgres |
| pg_settings_wal_buffers_bytes | Postgres |
| pg_settings_wal_compression | Postgres |
| pg_settings_wal_init_zero | Postgres |
| pg_settings_wal_keep_segments | Postgres |
| pg_settings_wal_log_hints | Postgres |
| pg_settings_wal_receiver_status_interval_seconds | Postgres |
| pg_settings_wal_receiver_timeout_seconds | Postgres |
| pg_settings_wal_recycle | Postgres |
| pg_settings_wal_retrieve_retry_interval_seconds | Postgres |
| pg_settings_wal_segment_size_bytes | Postgres |
| pg_settings_wal_sender_timeout_seconds | Postgres |
| pg_settings_wal_writer_delay_seconds | Postgres |
| pg_settings_wal_writer_flush_after_bytes | Postgres |
| pg_settings_work_mem_bytes | Postgres |
| pg_settings_zero_damaged_pages | Postgres |
| pg_stat_archiver_archived_count | Postgres |
| pg_stat_archiver_failed_count | Postgres |
| pg_stat_archiver_last_archive_age | Postgres |
| pg_stat_bgwriter_buffers_alloc | Postgres |
| pg_stat_bgwriter_buffers_backend | Postgres |
| pg_stat_bgwriter_buffers_backend_fsync | Postgres |
| pg_stat_bgwriter_buffers_checkpoint | Postgres |
| pg_stat_bgwriter_buffers_clean | Postgres |
| pg_stat_bgwriter_checkpoint_sync_time | Postgres |
| pg_stat_bgwriter_checkpoint_write_time | Postgres |
| pg_stat_bgwriter_checkpoints_req | Postgres |
| pg_stat_bgwriter_checkpoints_timed | Postgres |
| pg_stat_bgwriter_maxwritten_clean | Postgres |
| pg_stat_bgwriter_stats_reset | Postgres |

</details>
<hr/>
<details>
  <summary>ClusterName,datname,job,namespace,pod,server,service,state (2)</summary>

| Metric | Source |
| ------ | ------ |
| pg_stat_activity_count | Postgres |
| pg_stat_activity_max_tx_duration | Postgres |

</details>
<hr/>
<details>
  <summary>ClusterName,job,mount_point,namespace,pod,server,service (2)</summary>

| Metric | Source |
| ------ | ------ |
| ccp_nodemx_disk_activity_sectors_read | Postgres |
| ccp_nodemx_disk_activity_sectors_written | Postgres |

</details>
<hr/>
<details>
  <summary>ClusterName,job,namespace,pod,quantile,service (1)</summary>

| Metric | Source |
| ------ | ------ |
| go_gc_duration_seconds | Postgres |

</details>
<hr/>
<details>
  <summary>ClusterName,datname,job,mode,namespace,pod,server,service (1)</summary>

| Metric | Source |
| ------ | ------ |
| pg_locks_count | Postgres |

</details>
<hr/>
<details>
  <summary>ClusterName,fs_type,job,mount_point,namespace,pod,server,service (4)</summary>

| Metric | Source |
| ------ | ------ |
| ccp_nodemx_data_disk_available_bytes | Postgres |
| ccp_nodemx_data_disk_free_file_nodes | Postgres |
| ccp_nodemx_data_disk_total_bytes | Postgres |
| ccp_nodemx_data_disk_total_file_nodes | Postgres |

</details>
<hr/>
<details>
  <summary>ClusterName,job,namespace,pod,server,service,short_version,version (1)</summary>

| Metric | Source |
| ------ | ------ |
| pg_static | Postgres |

</details>
<hr/>
<details>
  <summary>ClusterName,datid,datname,job,namespace,pod,server,service (22)</summary>

| Metric | Source |
| ------ | ------ |
| pg_stat_database_blk_read_time | Postgres |
| pg_stat_database_blk_write_time | Postgres |
| pg_stat_database_blks_hit | Postgres |
| pg_stat_database_blks_read | Postgres |
| pg_stat_database_conflicts | Postgres |
| pg_stat_database_conflicts_confl_bufferpin | Postgres |
| pg_stat_database_conflicts_confl_deadlock | Postgres |
| pg_stat_database_conflicts_confl_lock | Postgres |
| pg_stat_database_conflicts_confl_snapshot | Postgres |
| pg_stat_database_conflicts_confl_tablespace | Postgres |
| pg_stat_database_deadlocks | Postgres |
| pg_stat_database_numbackends | Postgres |
| pg_stat_database_stats_reset | Postgres |
| pg_stat_database_temp_bytes | Postgres |
| pg_stat_database_temp_files | Postgres |
| pg_stat_database_tup_deleted | Postgres |
| pg_stat_database_tup_fetched | Postgres |
| pg_stat_database_tup_inserted | Postgres |
| pg_stat_database_tup_returned | Postgres |
| pg_stat_database_tup_updated | Postgres |
| pg_stat_database_xact_commit | Postgres |
| pg_stat_database_xact_rollback | Postgres |

</details>
<hr/>
<details>
  <summary>ClusterName,job,namespace,pod,service (39)</summary>

| Metric | Source |
| ------ | ------ |
| go_gc_duration_seconds_count | Postgres |
| go_gc_duration_seconds_sum | Postgres |
| go_goroutines | Postgres |
| go_memstats_alloc_bytes | Postgres |
| go_memstats_alloc_bytes_total | Postgres |
| go_memstats_buck_hash_sys_bytes | Postgres |
| go_memstats_frees_total | Postgres |
| go_memstats_gc_cpu_fraction | Postgres |
| go_memstats_gc_sys_bytes | Postgres |
| go_memstats_heap_alloc_bytes | Postgres |
| go_memstats_heap_idle_bytes | Postgres |
| go_memstats_heap_inuse_bytes | Postgres |
| go_memstats_heap_objects | Postgres |
| go_memstats_heap_released_bytes | Postgres |
| go_memstats_heap_sys_bytes | Postgres |
| go_memstats_last_gc_time_seconds | Postgres |
| go_memstats_lookups_total | Postgres |
| go_memstats_mallocs_total | Postgres |
| go_memstats_mcache_inuse_bytes | Postgres |
| go_memstats_mcache_sys_bytes | Postgres |
| go_memstats_mspan_inuse_bytes | Postgres |
| go_memstats_mspan_sys_bytes | Postgres |
| go_memstats_next_gc_bytes | Postgres |
| go_memstats_other_sys_bytes | Postgres |
| go_memstats_stack_inuse_bytes | Postgres |
| go_memstats_stack_sys_bytes | Postgres |
| go_memstats_sys_bytes | Postgres |
| go_threads | Postgres |
| pg_exporter_last_scrape_duration_seconds | Postgres |
| pg_exporter_last_scrape_error | Postgres |
| pg_exporter_scrapes_total | Postgres |
| pg_up | Postgres |
| process_cpu_seconds_total | Postgres |
| process_max_fds | Postgres |
| process_open_fds | Postgres |
| process_resident_memory_bytes | Postgres |
| process_start_time_seconds | Postgres |
| process_virtual_memory_bytes | Postgres |
| process_virtual_memory_max_bytes | Postgres |

</details>
<hr/>
<details>
  <summary>ClusterName,backup_type,job,namespace,pod,server,service,stanza (3)</summary>

| Metric | Source |
| ------ | ------ |
| ccp_backrest_last_info_backup_runtime_seconds | Postgres |
| ccp_backrest_last_info_repo_backup_size_bytes | Postgres |
| ccp_backrest_last_info_repo_total_size_bytes | Postgres |

</details>
<hr/>
<details>
  <summary>ClusterName,job,namespace,pod,replica,replica_port,server,service (1)</summary>

| Metric | Source |
| ------ | ------ |
| ccp_replication_lag_size_bytes | Postgres |

</details>
<hr/>
<details>
  <summary>ClusterName,dbname,job,namespace,pod,server,service (15)</summary>

| Metric | Source |
| ------ | ------ |
| ccp_data_checksum_failure_time_since_last_failure_seconds | Postgres |
| ccp_database_size_bytes | Postgres |
| ccp_stat_database_blks_hit | Postgres |
| ccp_stat_database_blks_read | Postgres |
| ccp_stat_database_conflicts | Postgres |
| ccp_stat_database_deadlocks | Postgres |
| ccp_stat_database_temp_bytes | Postgres |
| ccp_stat_database_temp_files | Postgres |
| ccp_stat_database_tup_deleted | Postgres |
| ccp_stat_database_tup_fetched | Postgres |
| ccp_stat_database_tup_inserted | Postgres |
| ccp_stat_database_tup_returned | Postgres |
| ccp_stat_database_tup_updated | Postgres |
| ccp_stat_database_xact_commit | Postgres |
| ccp_stat_database_xact_rollback | Postgres |

</details>
<hr/>
<details>
  <summary>ClusterName,dbname,job,namespace,pod,relname,schemaname,server,service (15)</summary>

| Metric | Source |
| ------ | ------ |
| ccp_stat_user_tables_analyze_count | Postgres |
| ccp_stat_user_tables_autoanalyze_count | Postgres |
| ccp_stat_user_tables_autovacuum_count | Postgres |
| ccp_stat_user_tables_idx_scan | Postgres |
| ccp_stat_user_tables_idx_tup_fetch | Postgres |
| ccp_stat_user_tables_n_dead_tup | Postgres |
| ccp_stat_user_tables_n_live_tup | Postgres |
| ccp_stat_user_tables_n_tup_del | Postgres |
| ccp_stat_user_tables_n_tup_hot_upd | Postgres |
| ccp_stat_user_tables_n_tup_ins | Postgres |
| ccp_stat_user_tables_n_tup_upd | Postgres |
| ccp_stat_user_tables_seq_scan | Postgres |
| ccp_stat_user_tables_seq_tup_read | Postgres |
| ccp_stat_user_tables_vacuum_count | Postgres |
| ccp_table_size_size_bytes | Postgres |

</details>
<hr/>
<details>
  <summary>ClusterName,job,namespace,pod,server,service,stanza (3)</summary>

| Metric | Source |
| ------ | ------ |
| ccp_backrest_last_diff_backup_time_since_completion_seconds | Postgres |
| ccp_backrest_last_full_backup_time_since_completion_seconds | Postgres |
| ccp_backrest_last_incr_backup_time_since_completion_seconds | Postgres |

</details>
<hr/>
<details>
  <summary>ClusterName,dbname,job,mode,namespace,pod,server,service (1)</summary>

| Metric | Source |
| ------ | ------ |
| ccp_locks_count | Postgres |

</details>
<hr/>
<details>
  <summary>ClusterName,datid,job,namespace,pod,server,service (17)</summary>

| Metric | Source |
| ------ | ------ |
| pg_stat_database_blk_read_time | Postgres |
| pg_stat_database_blk_write_time | Postgres |
| pg_stat_database_blks_hit | Postgres |
| pg_stat_database_blks_read | Postgres |
| pg_stat_database_conflicts | Postgres |
| pg_stat_database_deadlocks | Postgres |
| pg_stat_database_numbackends | Postgres |
| pg_stat_database_stats_reset | Postgres |
| pg_stat_database_temp_bytes | Postgres |
| pg_stat_database_temp_files | Postgres |
| pg_stat_database_tup_deleted | Postgres |
| pg_stat_database_tup_fetched | Postgres |
| pg_stat_database_tup_inserted | Postgres |
| pg_stat_database_tup_returned | Postgres |
| pg_stat_database_tup_updated | Postgres |
| pg_stat_database_xact_commit | Postgres |
| pg_stat_database_xact_rollback | Postgres |

</details>
<hr/>
<details>
  <summary>ClusterName,interface,job,namespace,pod,server,service (4)</summary>

| Metric | Source |
| ------ | ------ |
| ccp_nodemx_network_rx_bytes | Postgres |
| ccp_nodemx_network_rx_packets | Postgres |
| ccp_nodemx_network_tx_bytes | Postgres |
| ccp_nodemx_network_tx_packets | Postgres |

</details>
<hr/>
<details>
  <summary>ClusterName,alloc,instance_no,job,kind,namespace,pod,service,usage (1)</summary>

| Metric | Source |
| ------ | ------ |
| erlang_vm_allocators | RabbitMQ |

</details>
<hr/>
<details>
  <summary>ClusterName,job,namespace,pod,service,usage (3)</summary>

| Metric | Source |
| ------ | ------ |
| erlang_vm_memory_atom_bytes_total | RabbitMQ |
| erlang_vm_memory_processes_bytes_total | RabbitMQ |
| erlang_vm_memory_system_bytes_total | RabbitMQ |

</details>
<hr/>
<details>
  <summary>ClusterName,id,job,namespace,pod,service,type (15)</summary>

| Metric | Source |
| ------ | ------ |
| erlang_vm_msacc_alloc_seconds_total | RabbitMQ |
| erlang_vm_msacc_aux_seconds_total | RabbitMQ |
| erlang_vm_msacc_bif_seconds_total | RabbitMQ |
| erlang_vm_msacc_busy_wait_seconds_total | RabbitMQ |
| erlang_vm_msacc_check_io_seconds_total | RabbitMQ |
| erlang_vm_msacc_emulator_seconds_total | RabbitMQ |
| erlang_vm_msacc_ets_seconds_total | RabbitMQ |
| erlang_vm_msacc_gc_full_seconds_total | RabbitMQ |
| erlang_vm_msacc_gc_seconds_total | RabbitMQ |
| erlang_vm_msacc_nif_seconds_total | RabbitMQ |
| erlang_vm_msacc_other_seconds_total | RabbitMQ |
| erlang_vm_msacc_port_seconds_total | RabbitMQ |
| erlang_vm_msacc_send_seconds_total | RabbitMQ |
| erlang_vm_msacc_sleep_seconds_total | RabbitMQ |
| erlang_vm_msacc_timers_seconds_total | RabbitMQ |

</details>
<hr/>
<details>
  <summary>ClusterName,job,namespace,pod,protocol,service (3)</summary>

| Metric | Source |
| ------ | ------ |
| rabbitmq_auth_attempts_failed_total | RabbitMQ |
| rabbitmq_auth_attempts_succeeded_total | RabbitMQ |
| rabbitmq_auth_attempts_total | RabbitMQ |

</details>
<hr/>
<details>
  <summary>ClusterName,content_type,encoding,job,namespace,pod,registry,service (2)</summary>

| Metric | Source |
| ------ | ------ |
| telemetry_scrape_encoded_size_bytes_count | RabbitMQ |
| telemetry_scrape_encoded_size_bytes_sum | RabbitMQ |

</details>
<hr/>
<details>
  <summary>ClusterName,job,kind,namespace,pod,service (1)</summary>

| Metric | Source |
| ------ | ------ |
| erlang_vm_memory_bytes_total | RabbitMQ |

</details>
<hr/>
<details>
  <summary>ClusterName,job,namespace,peer,pod,service (16)</summary>

| Metric | Source |
| ------ | ------ |
| erlang_vm_dist_node_queue_size_bytes | RabbitMQ |
| erlang_vm_dist_node_state | RabbitMQ |
| erlang_vm_dist_port_input_bytes | RabbitMQ |
| erlang_vm_dist_port_memory_bytes | RabbitMQ |
| erlang_vm_dist_port_output_bytes | RabbitMQ |
| erlang_vm_dist_port_queue_size_bytes | RabbitMQ |
| erlang_vm_dist_recv_avg_bytes | RabbitMQ |
| erlang_vm_dist_recv_bytes | RabbitMQ |
| erlang_vm_dist_recv_cnt | RabbitMQ |
| erlang_vm_dist_recv_dvi_bytes | RabbitMQ |
| erlang_vm_dist_recv_max_bytes | RabbitMQ |
| erlang_vm_dist_send_avg_bytes | RabbitMQ |
| erlang_vm_dist_send_bytes | RabbitMQ |
| erlang_vm_dist_send_cnt | RabbitMQ |
| erlang_vm_dist_send_max_bytes | RabbitMQ |
| erlang_vm_dist_send_pend_bytes | RabbitMQ |

</details>
<hr/>
<details>
  <summary>ClusterName,job,namespace,pod,service (141)</summary>

| Metric | Source |
| ------ | ------ |
| erlang_mnesia_committed_transactions | RabbitMQ |
| erlang_mnesia_failed_transactions | RabbitMQ |
| erlang_mnesia_held_locks | RabbitMQ |
| erlang_mnesia_lock_queue | RabbitMQ |
| erlang_mnesia_logged_transactions | RabbitMQ |
| erlang_mnesia_restarted_transactions | RabbitMQ |
| erlang_mnesia_transaction_coordinators | RabbitMQ |
| erlang_mnesia_transaction_participants | RabbitMQ |
| erlang_vm_atom_count | RabbitMQ |
| erlang_vm_atom_limit | RabbitMQ |
| erlang_vm_dirty_cpu_schedulers | RabbitMQ |
| erlang_vm_dirty_cpu_schedulers_online | RabbitMQ |
| erlang_vm_dirty_io_schedulers | RabbitMQ |
| erlang_vm_ets_limit | RabbitMQ |
| erlang_vm_logical_processors | RabbitMQ |
| erlang_vm_logical_processors_available | RabbitMQ |
| erlang_vm_logical_processors_online | RabbitMQ |
| erlang_vm_memory_dets_tables | RabbitMQ |
| erlang_vm_memory_ets_tables | RabbitMQ |
| erlang_vm_port_count | RabbitMQ |
| erlang_vm_port_limit | RabbitMQ |
| erlang_vm_process_count | RabbitMQ |
| erlang_vm_process_limit | RabbitMQ |
| erlang_vm_schedulers | RabbitMQ |
| erlang_vm_schedulers_online | RabbitMQ |
| erlang_vm_smp_support | RabbitMQ |
| erlang_vm_statistics_bytes_output_total | RabbitMQ |
| erlang_vm_statistics_bytes_received_total | RabbitMQ |
| erlang_vm_statistics_context_switches | RabbitMQ |
| erlang_vm_statistics_dirty_cpu_run_queue_length | RabbitMQ |
| erlang_vm_statistics_dirty_io_run_queue_length | RabbitMQ |
| erlang_vm_statistics_garbage_collection_bytes_reclaimed | RabbitMQ |
| erlang_vm_statistics_garbage_collection_number_of_gcs | RabbitMQ |
| erlang_vm_statistics_garbage_collection_words_reclaimed | RabbitMQ |
| erlang_vm_statistics_reductions_total | RabbitMQ |
| erlang_vm_statistics_run_queues_length_total | RabbitMQ |
| erlang_vm_statistics_runtime_milliseconds | RabbitMQ |
| erlang_vm_statistics_wallclock_time_milliseconds | RabbitMQ |
| erlang_vm_thread_pool_size | RabbitMQ |
| erlang_vm_threads | RabbitMQ |
| erlang_vm_time_correction | RabbitMQ |
| erlang_vm_wordsize_bytes | RabbitMQ |
| rabbitmq_channel_acks_uncommitted | RabbitMQ |
| rabbitmq_channel_consumers | RabbitMQ |
| rabbitmq_channel_get_ack_total | RabbitMQ |
| rabbitmq_channel_get_empty_total | RabbitMQ |
| rabbitmq_channel_get_total | RabbitMQ |
| rabbitmq_channel_messages_acked_total | RabbitMQ |
| rabbitmq_channel_messages_confirmed_total | RabbitMQ |
| rabbitmq_channel_messages_delivered_ack_total | RabbitMQ |
| rabbitmq_channel_messages_delivered_total | RabbitMQ |
| rabbitmq_channel_messages_published_total | RabbitMQ |
| rabbitmq_channel_messages_redelivered_total | RabbitMQ |
| rabbitmq_channel_messages_unacked | RabbitMQ |
| rabbitmq_channel_messages_uncommitted | RabbitMQ |
| rabbitmq_channel_messages_unconfirmed | RabbitMQ |
| rabbitmq_channel_messages_unroutable_dropped_total | RabbitMQ |
| rabbitmq_channel_messages_unroutable_returned_total | RabbitMQ |
| rabbitmq_channel_prefetch | RabbitMQ |
| rabbitmq_channel_process_reductions_total | RabbitMQ |
| rabbitmq_channels | RabbitMQ |
| rabbitmq_channels_closed_total | RabbitMQ |
| rabbitmq_channels_opened_total | RabbitMQ |
| rabbitmq_connection_channels | RabbitMQ |
| rabbitmq_connection_incoming_bytes_total | RabbitMQ |
| rabbitmq_connection_incoming_packets_total | RabbitMQ |
| rabbitmq_connection_outgoing_bytes_total | RabbitMQ |
| rabbitmq_connection_outgoing_packets_total | RabbitMQ |
| rabbitmq_connection_pending_packets | RabbitMQ |
| rabbitmq_connection_process_reductions_total | RabbitMQ |
| rabbitmq_connections | RabbitMQ |
| rabbitmq_connections_closed_total | RabbitMQ |
| rabbitmq_connections_opened_total | RabbitMQ |
| rabbitmq_consumer_prefetch | RabbitMQ |
| rabbitmq_consumers | RabbitMQ |
| rabbitmq_disk_space_available_bytes | RabbitMQ |
| rabbitmq_disk_space_available_limit_bytes | RabbitMQ |
| rabbitmq_erlang_gc_reclaimed_bytes_total | RabbitMQ |
| rabbitmq_erlang_gc_runs_total | RabbitMQ |
| rabbitmq_erlang_net_ticktime_seconds | RabbitMQ |
| rabbitmq_erlang_processes_limit | RabbitMQ |
| rabbitmq_erlang_processes_used | RabbitMQ |
| rabbitmq_erlang_scheduler_context_switches_total | RabbitMQ |
| rabbitmq_erlang_scheduler_run_queue | RabbitMQ |
| rabbitmq_erlang_uptime_seconds | RabbitMQ |
| rabbitmq_io_open_attempt_ops_total | RabbitMQ |
| rabbitmq_io_open_attempt_time_seconds_total | RabbitMQ |
| rabbitmq_io_read_bytes_total | RabbitMQ |
| rabbitmq_io_read_ops_total | RabbitMQ |
| rabbitmq_io_read_time_seconds_total | RabbitMQ |
| rabbitmq_io_reopen_ops_total | RabbitMQ |
| rabbitmq_io_seek_ops_total | RabbitMQ |
| rabbitmq_io_seek_time_seconds_total | RabbitMQ |
| rabbitmq_io_sync_ops_total | RabbitMQ |
| rabbitmq_io_sync_time_seconds_total | RabbitMQ |
| rabbitmq_io_write_bytes_total | RabbitMQ |
| rabbitmq_io_write_ops_total | RabbitMQ |
| rabbitmq_io_write_time_seconds_total | RabbitMQ |
| rabbitmq_msg_store_read_total | RabbitMQ |
| rabbitmq_msg_store_write_total | RabbitMQ |
| rabbitmq_process_max_fds | RabbitMQ |
| rabbitmq_process_max_tcp_sockets | RabbitMQ |
| rabbitmq_process_open_fds | RabbitMQ |
| rabbitmq_process_open_tcp_sockets | RabbitMQ |
| rabbitmq_process_resident_memory_bytes | RabbitMQ |
| rabbitmq_queue_consumer_utilisation | RabbitMQ |
| rabbitmq_queue_consumers | RabbitMQ |
| rabbitmq_queue_disk_reads_total | RabbitMQ |
| rabbitmq_queue_disk_writes_total | RabbitMQ |
| rabbitmq_queue_index_journal_write_ops_total | RabbitMQ |
| rabbitmq_queue_index_read_ops_total | RabbitMQ |
| rabbitmq_queue_index_write_ops_total | RabbitMQ |
| rabbitmq_queue_messages | RabbitMQ |
| rabbitmq_queue_messages_bytes | RabbitMQ |
| rabbitmq_queue_messages_paged_out | RabbitMQ |
| rabbitmq_queue_messages_paged_out_bytes | RabbitMQ |
| rabbitmq_queue_messages_persistent | RabbitMQ |
| rabbitmq_queue_messages_published_total | RabbitMQ |
| rabbitmq_queue_messages_ram | RabbitMQ |
| rabbitmq_queue_messages_ram_bytes | RabbitMQ |
| rabbitmq_queue_messages_ready | RabbitMQ |
| rabbitmq_queue_messages_ready_bytes | RabbitMQ |
| rabbitmq_queue_messages_ready_ram | RabbitMQ |
| rabbitmq_queue_messages_unacked | RabbitMQ |
| rabbitmq_queue_messages_unacked_bytes | RabbitMQ |
| rabbitmq_queue_messages_unacked_ram | RabbitMQ |
| rabbitmq_queue_process_memory_bytes | RabbitMQ |
| rabbitmq_queue_process_reductions_total | RabbitMQ |
| rabbitmq_queues | RabbitMQ |
| rabbitmq_queues_created_total | RabbitMQ |
| rabbitmq_queues_declared_total | RabbitMQ |
| rabbitmq_queues_deleted_total | RabbitMQ |
| rabbitmq_raft_entry_commit_latency_seconds | RabbitMQ |
| rabbitmq_raft_log_commit_index | RabbitMQ |
| rabbitmq_raft_log_last_applied_index | RabbitMQ |
| rabbitmq_raft_log_last_written_index | RabbitMQ |
| rabbitmq_raft_log_snapshot_index | RabbitMQ |
| rabbitmq_raft_term_total | RabbitMQ |
| rabbitmq_resident_memory_limit_bytes | RabbitMQ |
| rabbitmq_schema_db_disk_tx_total | RabbitMQ |
| rabbitmq_schema_db_ram_tx_total | RabbitMQ |

</details>
<hr/>
<details>
  <summary>ClusterName,job,namespace,peer,pod,service,type (9)</summary>

| Metric | Source |
| ------ | ------ |
| erlang_vm_dist_proc_heap_size_words | RabbitMQ |
| erlang_vm_dist_proc_memory_bytes | RabbitMQ |
| erlang_vm_dist_proc_message_queue_len | RabbitMQ |
| erlang_vm_dist_proc_min_bin_vheap_size_words | RabbitMQ |
| erlang_vm_dist_proc_min_heap_size_words | RabbitMQ |
| erlang_vm_dist_proc_reductions | RabbitMQ |
| erlang_vm_dist_proc_stack_size_words | RabbitMQ |
| erlang_vm_dist_proc_status | RabbitMQ |
| erlang_vm_dist_proc_total_heap_size_words | RabbitMQ |

</details>
<hr/>
<details>
  <summary>ClusterName,content_type,job,namespace,pod,registry,service (4)</summary>

| Metric | Source |
| ------ | ------ |
| telemetry_scrape_duration_seconds_count | RabbitMQ |
| telemetry_scrape_duration_seconds_sum | RabbitMQ |
| telemetry_scrape_size_bytes_count | RabbitMQ |
| telemetry_scrape_size_bytes_sum | RabbitMQ |

</details>
</details>

## By Source
This table lists the dimensions and metrics associated with each type of metric source (such as CAS, SAS services written in Go, or SAS services written in Java).
<details>
  <summary>Sources</summary>
<hr/>
<details>
  <summary>CAS (19)</summary>
<b>CAS</b>
<hr/>

|  Metric | Dimensions |
| ---------- | ------ |
| cas_nodes | ClusterName,<br>cas_node,<br>cas_node_type,<br>cas_server,<br>connected,<br>job,<br>namespace,<br>pod,<br>uuid |
| cas_grid_idle_seconds | ClusterName,<br>cas_server,<br>job,<br>namespace,<br>pod |
| cas_grid_sessions_created_total | ClusterName,<br>cas_server,<br>job,<br>namespace,<br>pod |
| cas_grid_sessions_current | ClusterName,<br>cas_server,<br>job,<br>namespace,<br>pod |
| cas_grid_sessions_max | ClusterName,<br>cas_server,<br>job,<br>namespace,<br>pod |
| cas_grid_start_time_seconds | ClusterName,<br>cas_server,<br>job,<br>namespace,<br>pod |
| cas_grid_uptime_seconds_total | ClusterName,<br>cas_server,<br>job,<br>namespace,<br>pod |
| cas_grid_state | ClusterName,<br>cas_server,<br>job,<br>namespace,<br>pod,<br>state |
| cas_node_cpu_time_seconds | ClusterName,<br>cas_node,<br>cas_node_type,<br>cas_server,<br>job,<br>namespace,<br>pod,<br>type |
| cas_node_mem_free_bytes | ClusterName,<br>cas_node,<br>cas_node_type,<br>cas_server,<br>job,<br>namespace,<br>pod,<br>type |
| cas_node_mem_size_bytes | ClusterName,<br>cas_node,<br>cas_node_type,<br>cas_server,<br>job,<br>namespace,<br>pod,<br>type |
| cas_node_fifteen_minute_cpu_load_avg | ClusterName,<br>cas_node,<br>cas_node_type,<br>cas_server,<br>job,<br>namespace,<br>pod |
| cas_node_five_minute_cpu_load_avg | ClusterName,<br>cas_node,<br>cas_node_type,<br>cas_server,<br>job,<br>namespace,<br>pod |
| cas_node_free_files | ClusterName,<br>cas_node,<br>cas_node_type,<br>cas_server,<br>job,<br>namespace,<br>pod |
| cas_node_inodes_free | ClusterName,<br>cas_node,<br>cas_node_type,<br>cas_server,<br>job,<br>namespace,<br>pod |
| cas_node_inodes_used | ClusterName,<br>cas_node,<br>cas_node_type,<br>cas_server,<br>job,<br>namespace,<br>pod |
| cas_node_max_open_files | ClusterName,<br>cas_node,<br>cas_node_type,<br>cas_server,<br>job,<br>namespace,<br>pod |
| cas_node_one_minute_cpu_load_avg | ClusterName,<br>cas_node,<br>cas_node_type,<br>cas_server,<br>job,<br>namespace,<br>pod |
| cas_node_open_files | ClusterName,<br>cas_node,<br>cas_node_type,<br>cas_server,<br>job,<br>namespace,<br>pod |

</details>
<hr/>
<details>
  <summary>Postgres (432)</summary>
<b>Postgres</b>
<hr/>

|  Metric | Dimensions |
| ---------- | ------ |
| pg_exporter_user_queries_load_error | ClusterName,<br>filename,<br>hashsum,<br>job,<br>namespace,<br>pod,<br>service |
| ccp_archive_command_status_seconds_since_last_fail | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_connection_stats_active | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_connection_stats_idle | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_connection_stats_idle_in_txn | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_connection_stats_max_blocked_query_time | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_connection_stats_max_connections | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_connection_stats_max_idle_in_txn_time | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_connection_stats_max_query_time | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_connection_stats_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_data_checksum_failure_time_since_last_failure_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_is_in_recovery_status | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_nodemx_cpu_limit | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_nodemx_cpu_request | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_nodemx_cpuacct_usage | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_nodemx_cpucfs_period_us | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_nodemx_cpucfs_quota_us | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_nodemx_cpustat_nr_periods | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_nodemx_cpustat_nr_throttled | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_nodemx_cpustat_throttled_time | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_nodemx_mem_active_anon | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_nodemx_mem_active_file | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_nodemx_mem_cache | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_nodemx_mem_inactive_anon | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_nodemx_mem_inactive_file | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_nodemx_mem_limit | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_nodemx_mem_mapped_file | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_nodemx_mem_request | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_nodemx_mem_rss | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_nodemx_process_count | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_pg_hba_checksum_status | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_pg_settings_checksum_status | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_postgresql_version_current | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_postmaster_runtime_start_time_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_postmaster_uptime_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_sequence_exhaustion_count | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_settings_gauge_checkpoint_completion_target | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_settings_gauge_checkpoint_timeout | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_settings_gauge_shared_buffers | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_settings_pending_restart_count | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_stat_bgwriter_buffers_alloc | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_stat_bgwriter_buffers_backend | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_stat_bgwriter_buffers_backend_fsync | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_stat_bgwriter_buffers_checkpoint | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_stat_bgwriter_buffers_clean | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_stat_bgwriter_checkpoint_sync_time | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_stat_bgwriter_checkpoint_write_time | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_stat_bgwriter_checkpoints_req | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_stat_bgwriter_checkpoints_timed | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_stat_bgwriter_maxwritten_clean | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_stat_bgwriter_stats_reset | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_transaction_wraparound_oldest_current_xid | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_transaction_wraparound_percent_towards_emergency_autovac | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_transaction_wraparound_percent_towards_wraparound | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_wal_activity_last_5_min_size_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_wal_activity_total_size_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_allow_system_table_mods | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_archive_timeout_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_array_nulls | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_authentication_timeout_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_autovacuum | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_autovacuum_analyze_scale_factor | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_autovacuum_analyze_threshold | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_autovacuum_freeze_max_age | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_autovacuum_max_workers | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_autovacuum_multixact_freeze_max_age | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_autovacuum_naptime_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_autovacuum_vacuum_cost_delay_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_autovacuum_vacuum_cost_limit | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_autovacuum_vacuum_scale_factor | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_autovacuum_vacuum_threshold | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_autovacuum_work_mem_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_backend_flush_after_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_bgwriter_delay_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_bgwriter_flush_after_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_bgwriter_lru_maxpages | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_bgwriter_lru_multiplier | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_block_size | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_bonjour | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_check_function_bodies | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_checkpoint_completion_target | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_checkpoint_flush_after_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_checkpoint_timeout_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_checkpoint_warning_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_commit_delay | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_commit_siblings | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_cpu_index_tuple_cost | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_cpu_operator_cost | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_cpu_tuple_cost | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_cursor_tuple_fraction | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_data_checksums | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_data_directory_mode | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_data_sync_retry | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_db_user_namespace | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_deadlock_timeout_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_debug_assertions | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_debug_pretty_print | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_debug_print_parse | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_debug_print_plan | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_debug_print_rewritten | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_default_statistics_target | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_default_transaction_deferrable | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_default_transaction_read_only | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_effective_cache_size_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_effective_io_concurrency | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_enable_bitmapscan | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_enable_gathermerge | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_enable_hashagg | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_enable_hashjoin | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_enable_indexonlyscan | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_enable_indexscan | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_enable_material | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_enable_mergejoin | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_enable_nestloop | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_enable_parallel_append | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_enable_parallel_hash | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_enable_partition_pruning | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_enable_partitionwise_aggregate | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_enable_partitionwise_join | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_enable_seqscan | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_enable_sort | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_enable_tidscan | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_escape_string_warning | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_exit_on_error | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_extra_float_digits | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_from_collapse_limit | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_fsync | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_full_page_writes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_geqo | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_geqo_effort | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_geqo_generations | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_geqo_pool_size | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_geqo_seed | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_geqo_selection_bias | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_geqo_threshold | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_gin_fuzzy_search_limit | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_gin_pending_list_limit_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_hot_standby | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_hot_standby_feedback | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_idle_in_transaction_session_timeout_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_ignore_checksum_failure | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_ignore_system_indexes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_integer_datetimes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_jit | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_jit_above_cost | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_jit_debugging_support | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_jit_dump_bitcode | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_jit_expressions | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_jit_inline_above_cost | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_jit_optimize_above_cost | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_jit_profiling_support | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_jit_tuple_deforming | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_join_collapse_limit | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_krb_caseins_users | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_lo_compat_privileges | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_lock_timeout_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_log_autovacuum_min_duration_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_log_checkpoints | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_log_connections | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_log_disconnections | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_log_duration | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_log_executor_stats | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_log_file_mode | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_log_hostname | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_log_lock_waits | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_log_min_duration_statement_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_log_parser_stats | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_log_planner_stats | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_log_replication_commands | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_log_rotation_age_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_log_rotation_size_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_log_statement_stats | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_log_temp_files_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_log_transaction_sample_rate | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_log_truncate_on_rotation | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_logging_collector | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_maintenance_work_mem_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_max_connections | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_max_files_per_process | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_max_function_args | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_max_identifier_length | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_max_index_keys | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_max_locks_per_transaction | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_max_logical_replication_workers | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_max_parallel_maintenance_workers | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_max_parallel_workers | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_max_parallel_workers_per_gather | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_max_pred_locks_per_page | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_max_pred_locks_per_relation | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_max_pred_locks_per_transaction | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_max_prepared_transactions | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_max_replication_slots | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_max_stack_depth_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_max_standby_archive_delay_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_max_standby_streaming_delay_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_max_sync_workers_per_subscription | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_max_wal_senders | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_max_wal_size_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_max_worker_processes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_min_parallel_index_scan_size_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_min_parallel_table_scan_size_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_min_wal_size_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_old_snapshot_threshold_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_operator_precedence_warning | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_parallel_leader_participation | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_parallel_setup_cost | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_parallel_tuple_cost | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_pg_stat_statements_max | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_pg_stat_statements_save | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_pg_stat_statements_track_utility | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_pgaudit_log_catalog | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_pgaudit_log_client | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_pgaudit_log_parameter | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_pgaudit_log_relation | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_pgaudit_log_statement_once | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_pgnodemx_cgroup_enabled | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_pgnodemx_containerized | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_pgnodemx_kdapi_enabled | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_plpgsql_check_asserts | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_plpgsql_print_strict_params | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_port | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_post_auth_delay_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_pre_auth_delay_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_quote_all_identifiers | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_random_page_cost | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_recovery_min_apply_delay_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_recovery_target_inclusive | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_restart_after_crash | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_row_security | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_segment_size_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_seq_page_cost | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_server_version_num | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_shared_buffers_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_ssl | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_ssl_passphrase_command_supports_reload | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_ssl_prefer_server_ciphers | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_standard_conforming_strings | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_statement_timeout_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_superuser_reserved_connections | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_synchronize_seqscans | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_syslog_sequence_numbers | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_syslog_split_messages | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_tcp_keepalives_count | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_tcp_keepalives_idle_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_tcp_keepalives_interval_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_tcp_user_timeout_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_temp_buffers_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_temp_file_limit_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_trace_notify | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_trace_sort | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_track_activities | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_track_activity_query_size_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_track_commit_timestamp | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_track_counts | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_track_io_timing | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_transaction_deferrable | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_transaction_read_only | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_transform_null_equals | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_unix_socket_permissions | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_update_process_title | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_vacuum_cleanup_index_scale_factor | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_vacuum_cost_delay_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_vacuum_cost_limit | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_vacuum_cost_page_dirty | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_vacuum_cost_page_hit | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_vacuum_cost_page_miss | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_vacuum_defer_cleanup_age | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_vacuum_freeze_min_age | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_vacuum_freeze_table_age | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_vacuum_multixact_freeze_min_age | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_vacuum_multixact_freeze_table_age | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_wal_block_size | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_wal_buffers_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_wal_compression | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_wal_init_zero | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_wal_keep_segments | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_wal_log_hints | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_wal_receiver_status_interval_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_wal_receiver_timeout_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_wal_recycle | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_wal_retrieve_retry_interval_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_wal_segment_size_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_wal_sender_timeout_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_wal_writer_delay_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_wal_writer_flush_after_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_work_mem_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_settings_zero_damaged_pages | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_archiver_archived_count | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_archiver_failed_count | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_archiver_last_archive_age | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_bgwriter_buffers_alloc | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_bgwriter_buffers_backend | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_bgwriter_buffers_backend_fsync | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_bgwriter_buffers_checkpoint | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_bgwriter_buffers_clean | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_bgwriter_checkpoint_sync_time | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_bgwriter_checkpoint_write_time | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_bgwriter_checkpoints_req | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_bgwriter_checkpoints_timed | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_bgwriter_maxwritten_clean | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_bgwriter_stats_reset | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_activity_count | ClusterName,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service,<br>state |
| pg_stat_activity_max_tx_duration | ClusterName,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service,<br>state |
| ccp_nodemx_disk_activity_sectors_read | ClusterName,<br>job,<br>mount_point,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_nodemx_disk_activity_sectors_written | ClusterName,<br>job,<br>mount_point,<br>namespace,<br>pod,<br>server,<br>service |
| go_gc_duration_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>quantile,<br>service |
| pg_locks_count | ClusterName,<br>datname,<br>job,<br>mode,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_nodemx_data_disk_available_bytes | ClusterName,<br>fs_type,<br>job,<br>mount_point,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_nodemx_data_disk_free_file_nodes | ClusterName,<br>fs_type,<br>job,<br>mount_point,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_nodemx_data_disk_total_bytes | ClusterName,<br>fs_type,<br>job,<br>mount_point,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_nodemx_data_disk_total_file_nodes | ClusterName,<br>fs_type,<br>job,<br>mount_point,<br>namespace,<br>pod,<br>server,<br>service |
| pg_static | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service,<br>short_version,<br>version |
| pg_stat_database_blk_read_time | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_database_blk_write_time | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_database_blks_hit | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_database_blks_read | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_database_conflicts | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_database_conflicts_confl_bufferpin | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_database_conflicts_confl_deadlock | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_database_conflicts_confl_lock | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_database_conflicts_confl_snapshot | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_database_conflicts_confl_tablespace | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_database_deadlocks | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_database_numbackends | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_database_stats_reset | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_database_temp_bytes | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_database_temp_files | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_database_tup_deleted | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_database_tup_fetched | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_database_tup_inserted | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_database_tup_returned | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_database_tup_updated | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_database_xact_commit | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_database_xact_rollback | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| go_gc_duration_seconds_count | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| go_gc_duration_seconds_sum | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| go_goroutines | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| go_memstats_alloc_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| go_memstats_alloc_bytes_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| go_memstats_buck_hash_sys_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| go_memstats_frees_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| go_memstats_gc_cpu_fraction | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| go_memstats_gc_sys_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| go_memstats_heap_alloc_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| go_memstats_heap_idle_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| go_memstats_heap_inuse_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| go_memstats_heap_objects | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| go_memstats_heap_released_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| go_memstats_heap_sys_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| go_memstats_last_gc_time_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| go_memstats_lookups_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| go_memstats_mallocs_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| go_memstats_mcache_inuse_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| go_memstats_mcache_sys_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| go_memstats_mspan_inuse_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| go_memstats_mspan_sys_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| go_memstats_next_gc_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| go_memstats_other_sys_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| go_memstats_stack_inuse_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| go_memstats_stack_sys_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| go_memstats_sys_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| go_threads | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| pg_exporter_last_scrape_duration_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| pg_exporter_last_scrape_error | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| pg_exporter_scrapes_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| pg_up | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| process_cpu_seconds_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| process_max_fds | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| process_open_fds | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| process_resident_memory_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| process_start_time_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| process_virtual_memory_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| process_virtual_memory_max_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| ccp_backrest_last_info_backup_runtime_seconds | ClusterName,<br>backup_type,<br>job,<br>namespace,<br>pod,<br>server,<br>service,<br>stanza |
| ccp_backrest_last_info_repo_backup_size_bytes | ClusterName,<br>backup_type,<br>job,<br>namespace,<br>pod,<br>server,<br>service,<br>stanza |
| ccp_backrest_last_info_repo_total_size_bytes | ClusterName,<br>backup_type,<br>job,<br>namespace,<br>pod,<br>server,<br>service,<br>stanza |
| ccp_replication_lag_size_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>replica,<br>replica_port,<br>server,<br>service |
| ccp_data_checksum_failure_time_since_last_failure_seconds | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_database_size_bytes | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_stat_database_blks_hit | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_stat_database_blks_read | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_stat_database_conflicts | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_stat_database_deadlocks | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_stat_database_temp_bytes | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_stat_database_temp_files | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_stat_database_tup_deleted | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_stat_database_tup_fetched | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_stat_database_tup_inserted | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_stat_database_tup_returned | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_stat_database_tup_updated | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_stat_database_xact_commit | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_stat_database_xact_rollback | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_stat_user_tables_analyze_count | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>relname,<br>schemaname,<br>server,<br>service |
| ccp_stat_user_tables_autoanalyze_count | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>relname,<br>schemaname,<br>server,<br>service |
| ccp_stat_user_tables_autovacuum_count | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>relname,<br>schemaname,<br>server,<br>service |
| ccp_stat_user_tables_idx_scan | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>relname,<br>schemaname,<br>server,<br>service |
| ccp_stat_user_tables_idx_tup_fetch | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>relname,<br>schemaname,<br>server,<br>service |
| ccp_stat_user_tables_n_dead_tup | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>relname,<br>schemaname,<br>server,<br>service |
| ccp_stat_user_tables_n_live_tup | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>relname,<br>schemaname,<br>server,<br>service |
| ccp_stat_user_tables_n_tup_del | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>relname,<br>schemaname,<br>server,<br>service |
| ccp_stat_user_tables_n_tup_hot_upd | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>relname,<br>schemaname,<br>server,<br>service |
| ccp_stat_user_tables_n_tup_ins | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>relname,<br>schemaname,<br>server,<br>service |
| ccp_stat_user_tables_n_tup_upd | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>relname,<br>schemaname,<br>server,<br>service |
| ccp_stat_user_tables_seq_scan | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>relname,<br>schemaname,<br>server,<br>service |
| ccp_stat_user_tables_seq_tup_read | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>relname,<br>schemaname,<br>server,<br>service |
| ccp_stat_user_tables_vacuum_count | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>relname,<br>schemaname,<br>server,<br>service |
| ccp_table_size_size_bytes | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>relname,<br>schemaname,<br>server,<br>service |
| ccp_backrest_last_diff_backup_time_since_completion_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service,<br>stanza |
| ccp_backrest_last_full_backup_time_since_completion_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service,<br>stanza |
| ccp_backrest_last_incr_backup_time_since_completion_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service,<br>stanza |
| ccp_locks_count | ClusterName,<br>dbname,<br>job,<br>mode,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_database_blk_read_time | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_database_blk_write_time | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_database_blks_hit | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_database_blks_read | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_database_conflicts | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_database_deadlocks | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_database_numbackends | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_database_stats_reset | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_database_temp_bytes | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_database_temp_files | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_database_tup_deleted | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_database_tup_fetched | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_database_tup_inserted | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_database_tup_returned | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_database_tup_updated | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_database_xact_commit | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| pg_stat_database_xact_rollback | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_nodemx_network_rx_bytes | ClusterName,<br>interface,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_nodemx_network_rx_packets | ClusterName,<br>interface,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_nodemx_network_tx_bytes | ClusterName,<br>interface,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_nodemx_network_tx_packets | ClusterName,<br>interface,<br>job,<br>namespace,<br>pod,<br>server,<br>service |

</details>
<hr/>
<details>
  <summary>RabbitMQ (195)</summary>
<b>RabbitMQ</b>
<hr/>

|  Metric | Dimensions |
| ---------- | ------ |
| erlang_vm_allocators | ClusterName,<br>alloc,<br>instance_no,<br>job,<br>kind,<br>namespace,<br>pod,<br>service,<br>usage |
| erlang_vm_memory_atom_bytes_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service,<br>usage |
| erlang_vm_memory_processes_bytes_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service,<br>usage |
| erlang_vm_memory_system_bytes_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service,<br>usage |
| erlang_vm_msacc_alloc_seconds_total | ClusterName,<br>id,<br>job,<br>namespace,<br>pod,<br>service,<br>type |
| erlang_vm_msacc_aux_seconds_total | ClusterName,<br>id,<br>job,<br>namespace,<br>pod,<br>service,<br>type |
| erlang_vm_msacc_bif_seconds_total | ClusterName,<br>id,<br>job,<br>namespace,<br>pod,<br>service,<br>type |
| erlang_vm_msacc_busy_wait_seconds_total | ClusterName,<br>id,<br>job,<br>namespace,<br>pod,<br>service,<br>type |
| erlang_vm_msacc_check_io_seconds_total | ClusterName,<br>id,<br>job,<br>namespace,<br>pod,<br>service,<br>type |
| erlang_vm_msacc_emulator_seconds_total | ClusterName,<br>id,<br>job,<br>namespace,<br>pod,<br>service,<br>type |
| erlang_vm_msacc_ets_seconds_total | ClusterName,<br>id,<br>job,<br>namespace,<br>pod,<br>service,<br>type |
| erlang_vm_msacc_gc_full_seconds_total | ClusterName,<br>id,<br>job,<br>namespace,<br>pod,<br>service,<br>type |
| erlang_vm_msacc_gc_seconds_total | ClusterName,<br>id,<br>job,<br>namespace,<br>pod,<br>service,<br>type |
| erlang_vm_msacc_nif_seconds_total | ClusterName,<br>id,<br>job,<br>namespace,<br>pod,<br>service,<br>type |
| erlang_vm_msacc_other_seconds_total | ClusterName,<br>id,<br>job,<br>namespace,<br>pod,<br>service,<br>type |
| erlang_vm_msacc_port_seconds_total | ClusterName,<br>id,<br>job,<br>namespace,<br>pod,<br>service,<br>type |
| erlang_vm_msacc_send_seconds_total | ClusterName,<br>id,<br>job,<br>namespace,<br>pod,<br>service,<br>type |
| erlang_vm_msacc_sleep_seconds_total | ClusterName,<br>id,<br>job,<br>namespace,<br>pod,<br>service,<br>type |
| erlang_vm_msacc_timers_seconds_total | ClusterName,<br>id,<br>job,<br>namespace,<br>pod,<br>service,<br>type |
| rabbitmq_auth_attempts_failed_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>protocol,<br>service |
| rabbitmq_auth_attempts_succeeded_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>protocol,<br>service |
| rabbitmq_auth_attempts_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>protocol,<br>service |
| telemetry_scrape_encoded_size_bytes_count | ClusterName,<br>content_type,<br>encoding,<br>job,<br>namespace,<br>pod,<br>registry,<br>service |
| telemetry_scrape_encoded_size_bytes_sum | ClusterName,<br>content_type,<br>encoding,<br>job,<br>namespace,<br>pod,<br>registry,<br>service |
| erlang_vm_memory_bytes_total | ClusterName,<br>job,<br>kind,<br>namespace,<br>pod,<br>service |
| erlang_vm_dist_node_queue_size_bytes | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service |
| erlang_vm_dist_node_state | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service |
| erlang_vm_dist_port_input_bytes | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service |
| erlang_vm_dist_port_memory_bytes | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service |
| erlang_vm_dist_port_output_bytes | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service |
| erlang_vm_dist_port_queue_size_bytes | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service |
| erlang_vm_dist_recv_avg_bytes | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service |
| erlang_vm_dist_recv_bytes | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service |
| erlang_vm_dist_recv_cnt | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service |
| erlang_vm_dist_recv_dvi_bytes | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service |
| erlang_vm_dist_recv_max_bytes | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service |
| erlang_vm_dist_send_avg_bytes | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service |
| erlang_vm_dist_send_bytes | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service |
| erlang_vm_dist_send_cnt | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service |
| erlang_vm_dist_send_max_bytes | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service |
| erlang_vm_dist_send_pend_bytes | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service |
| erlang_mnesia_committed_transactions | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| erlang_mnesia_failed_transactions | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| erlang_mnesia_held_locks | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| erlang_mnesia_lock_queue | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| erlang_mnesia_logged_transactions | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| erlang_mnesia_restarted_transactions | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| erlang_mnesia_transaction_coordinators | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| erlang_mnesia_transaction_participants | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| erlang_vm_atom_count | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| erlang_vm_atom_limit | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| erlang_vm_dirty_cpu_schedulers | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| erlang_vm_dirty_cpu_schedulers_online | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| erlang_vm_dirty_io_schedulers | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| erlang_vm_ets_limit | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| erlang_vm_logical_processors | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| erlang_vm_logical_processors_available | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| erlang_vm_logical_processors_online | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| erlang_vm_memory_dets_tables | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| erlang_vm_memory_ets_tables | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| erlang_vm_port_count | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| erlang_vm_port_limit | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| erlang_vm_process_count | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| erlang_vm_process_limit | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| erlang_vm_schedulers | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| erlang_vm_schedulers_online | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| erlang_vm_smp_support | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| erlang_vm_statistics_bytes_output_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| erlang_vm_statistics_bytes_received_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| erlang_vm_statistics_context_switches | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| erlang_vm_statistics_dirty_cpu_run_queue_length | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| erlang_vm_statistics_dirty_io_run_queue_length | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| erlang_vm_statistics_garbage_collection_bytes_reclaimed | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| erlang_vm_statistics_garbage_collection_number_of_gcs | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| erlang_vm_statistics_garbage_collection_words_reclaimed | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| erlang_vm_statistics_reductions_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| erlang_vm_statistics_run_queues_length_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| erlang_vm_statistics_runtime_milliseconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| erlang_vm_statistics_wallclock_time_milliseconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| erlang_vm_thread_pool_size | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| erlang_vm_threads | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| erlang_vm_time_correction | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| erlang_vm_wordsize_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_channel_acks_uncommitted | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_channel_consumers | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_channel_get_ack_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_channel_get_empty_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_channel_get_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_channel_messages_acked_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_channel_messages_confirmed_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_channel_messages_delivered_ack_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_channel_messages_delivered_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_channel_messages_published_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_channel_messages_redelivered_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_channel_messages_unacked | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_channel_messages_uncommitted | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_channel_messages_unconfirmed | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_channel_messages_unroutable_dropped_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_channel_messages_unroutable_returned_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_channel_prefetch | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_channel_process_reductions_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_channels | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_channels_closed_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_channels_opened_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_connection_channels | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_connection_incoming_bytes_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_connection_incoming_packets_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_connection_outgoing_bytes_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_connection_outgoing_packets_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_connection_pending_packets | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_connection_process_reductions_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_connections | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_connections_closed_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_connections_opened_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_consumer_prefetch | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_consumers | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_disk_space_available_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_disk_space_available_limit_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_erlang_gc_reclaimed_bytes_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_erlang_gc_runs_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_erlang_net_ticktime_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_erlang_processes_limit | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_erlang_processes_used | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_erlang_scheduler_context_switches_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_erlang_scheduler_run_queue | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_erlang_uptime_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_io_open_attempt_ops_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_io_open_attempt_time_seconds_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_io_read_bytes_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_io_read_ops_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_io_read_time_seconds_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_io_reopen_ops_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_io_seek_ops_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_io_seek_time_seconds_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_io_sync_ops_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_io_sync_time_seconds_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_io_write_bytes_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_io_write_ops_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_io_write_time_seconds_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_msg_store_read_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_msg_store_write_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_process_max_fds | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_process_max_tcp_sockets | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_process_open_fds | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_process_open_tcp_sockets | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_process_resident_memory_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_queue_consumer_utilisation | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_queue_consumers | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_queue_disk_reads_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_queue_disk_writes_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_queue_index_journal_write_ops_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_queue_index_read_ops_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_queue_index_write_ops_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_queue_messages | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_queue_messages_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_queue_messages_paged_out | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_queue_messages_paged_out_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_queue_messages_persistent | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_queue_messages_published_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_queue_messages_ram | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_queue_messages_ram_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_queue_messages_ready | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_queue_messages_ready_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_queue_messages_ready_ram | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_queue_messages_unacked | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_queue_messages_unacked_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_queue_messages_unacked_ram | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_queue_process_memory_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_queue_process_reductions_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_queues | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_queues_created_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_queues_declared_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_queues_deleted_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_raft_entry_commit_latency_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_raft_log_commit_index | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_raft_log_last_applied_index | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_raft_log_last_written_index | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_raft_log_snapshot_index | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_raft_term_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_resident_memory_limit_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_schema_db_disk_tx_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| rabbitmq_schema_db_ram_tx_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service |
| erlang_vm_dist_proc_heap_size_words | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service,<br>type |
| erlang_vm_dist_proc_memory_bytes | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service,<br>type |
| erlang_vm_dist_proc_message_queue_len | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service,<br>type |
| erlang_vm_dist_proc_min_bin_vheap_size_words | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service,<br>type |
| erlang_vm_dist_proc_min_heap_size_words | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service,<br>type |
| erlang_vm_dist_proc_reductions | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service,<br>type |
| erlang_vm_dist_proc_stack_size_words | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service,<br>type |
| erlang_vm_dist_proc_status | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service,<br>type |
| erlang_vm_dist_proc_total_heap_size_words | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service,<br>type |
| telemetry_scrape_duration_seconds_count | ClusterName,<br>content_type,<br>job,<br>namespace,<br>pod,<br>registry,<br>service |
| telemetry_scrape_duration_seconds_sum | ClusterName,<br>content_type,<br>job,<br>namespace,<br>pod,<br>registry,<br>service |
| telemetry_scrape_size_bytes_count | ClusterName,<br>content_type,<br>job,<br>namespace,<br>pod,<br>registry,<br>service |
| telemetry_scrape_size_bytes_sum | ClusterName,<br>content_type,<br>job,<br>namespace,<br>pod,<br>registry,<br>service |

</details>
<hr/>
<details>
  <summary>SAS Go Microservices (81)</summary>
<b>SAS Go Microservices</b>
<hr/>

|  Metric | Dimensions |
| ---------- | ------ |
| go_gc_duration_seconds | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>quantile,<br>sas_service_base,<br>service |
| sas_db_connections_max | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service,<br>state |
| sas_db_pool_connections | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service,<br>state |
| arke_request_elapsed | ClusterName,<br>job,<br>method,<br>namespace,<br>node,<br>pod,<br>quantile,<br>sas_service_base,<br>service,<br>status |
| sas_db_connections_max | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>schema,<br>service,<br>state |
| sas_db_pool_connections | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>schema,<br>service,<br>state |
| sas_db_closed_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>reason,<br>sas_service_base,<br>service |
| sas_db_wait_seconds | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>schema,<br>service |
| sas_db_wait_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>schema,<br>service |
| arke_client_active_messages | ClientIdentitifer,<br>ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| arke_client_consumed_total | ClientIdentitifer,<br>ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| arke_client_produced_total | ClientIdentitifer,<br>ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| arke_client_streams | ClientIdentitifer,<br>ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| arke_client_active_messages | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| arke_client_consumed_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| arke_client_produced_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| arke_client_streams | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| arke_recvmsg_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| arke_request_elapsed_count | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| arke_request_elapsed_sum | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| arke_request_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| arke_sendmsg_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| go_gc_duration_seconds_count | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| go_gc_duration_seconds_sum | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| go_goroutines | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| go_memstats_alloc_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| go_memstats_alloc_bytes_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| go_memstats_buck_hash_sys_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| go_memstats_frees_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| go_memstats_gc_cpu_fraction | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| go_memstats_gc_sys_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| go_memstats_heap_alloc_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| go_memstats_heap_idle_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| go_memstats_heap_inuse_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| go_memstats_heap_objects | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| go_memstats_heap_released_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| go_memstats_heap_sys_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| go_memstats_last_gc_time_seconds | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| go_memstats_lookups_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| go_memstats_mallocs_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| go_memstats_mcache_inuse_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| go_memstats_mcache_sys_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| go_memstats_mspan_inuse_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| go_memstats_mspan_sys_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| go_memstats_next_gc_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| go_memstats_other_sys_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| go_memstats_stack_inuse_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| go_memstats_stack_sys_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| go_memstats_sys_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| go_threads | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| process_cpu_seconds_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| process_max_fds | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| process_open_fds | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| process_resident_memory_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| process_start_time_seconds | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| process_virtual_memory_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| process_virtual_memory_max_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| runtime_alloc_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| runtime_free_count | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| runtime_gc_pause_ns_count | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| runtime_gc_pause_ns_sum | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| runtime_heap_objects | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| runtime_malloc_count | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| runtime_num_goroutines | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| runtime_sys_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| runtime_total_gc_pause_ns | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| runtime_total_gc_runs | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| sas_db_wait_seconds | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| sas_db_wait_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| sas_maps_esri_query_duration_seconds_count | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| sas_maps_esri_query_duration_seconds_sum | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| sas_maps_report_polling_attempts_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| sas_maps_report_query_duration_seconds_count | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| sas_maps_report_query_duration_seconds_sum | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| arke_recvmsg_total | ClusterName,<br>job,<br>method,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service,<br>status |
| arke_request_elapsed_count | ClusterName,<br>job,<br>method,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service,<br>status |
| arke_request_elapsed_sum | ClusterName,<br>job,<br>method,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service,<br>status |
| arke_request_total | ClusterName,<br>job,<br>method,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service,<br>status |
| arke_sendmsg_total | ClusterName,<br>job,<br>method,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service,<br>status |
| log_events_total | ClusterName,<br>job,<br>level,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| sas_db_closed_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>reason,<br>sas_service_base,<br>schema,<br>service |

</details>
<hr/>
<details>
  <summary>SAS Java Microservices (82)</summary>
<b>SAS Java Microservices</b>
<hr/>

|  Metric | Dimensions |
| ---------- | ------ |
| http_server_requests_seconds_count | ClusterName,<br>job,<br>method,<br>namespace,<br>node,<br>outcome,<br>pod,<br>sas_service_base,<br>status,<br>uri |
| http_server_requests_seconds_max | ClusterName,<br>job,<br>method,<br>namespace,<br>node,<br>outcome,<br>pod,<br>sas_service_base,<br>status,<br>uri |
| http_server_requests_seconds_sum | ClusterName,<br>job,<br>method,<br>namespace,<br>node,<br>outcome,<br>pod,<br>sas_service_base,<br>status,<br>uri |
| log_events_total | ClusterName,<br>job,<br>level,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| jvm_buffer_count_buffers | ClusterName,<br>id,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| jvm_buffer_memory_used_bytes | ClusterName,<br>id,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| jvm_buffer_total_capacity_bytes | ClusterName,<br>id,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| jvm_gc_pause_seconds_count | ClusterName,<br>action,<br>cause,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| jvm_gc_pause_seconds_max | ClusterName,<br>action,<br>cause,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| jvm_gc_pause_seconds_sum | ClusterName,<br>action,<br>cause,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| spring_rabbitmq_listener_seconds_count | ClusterName,<br>job,<br>listener_id,<br>namespace,<br>node,<br>pod,<br>queue,<br>result,<br>sas_service_base |
| spring_rabbitmq_listener_seconds_max | ClusterName,<br>job,<br>listener_id,<br>namespace,<br>node,<br>pod,<br>queue,<br>result,<br>sas_service_base |
| spring_rabbitmq_listener_seconds_sum | ClusterName,<br>job,<br>listener_id,<br>namespace,<br>node,<br>pod,<br>queue,<br>result,<br>sas_service_base |
| http_client_requests_seconds_count | ClusterName,<br>job,<br>method,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>status,<br>uri |
| http_client_requests_seconds_max | ClusterName,<br>job,<br>method,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>status,<br>uri |
| http_client_requests_seconds_sum | ClusterName,<br>job,<br>method,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>status,<br>uri |
| jvm_memory_committed_bytes | ClusterName,<br>area,<br>id,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| jvm_memory_max_bytes | ClusterName,<br>area,<br>id,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| jvm_memory_used_bytes | ClusterName,<br>area,<br>id,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| jvm_threads_states_threads | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>state |
| jdbc_connections_active | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| jdbc_connections_idle | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| jdbc_connections_max | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| jdbc_connections_min | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| rabbitmq_acknowledged_published_total | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| rabbitmq_acknowledged_total | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| rabbitmq_channels | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| rabbitmq_connections | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| rabbitmq_consumed_total | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| rabbitmq_failed_to_publish_total | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| rabbitmq_not_acknowledged_published_total | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| rabbitmq_published_total | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| rabbitmq_rejected_total | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| rabbitmq_unrouted_published_total | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| tomcat_global_error_total | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| tomcat_global_received_bytes_total | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| tomcat_global_request_max_seconds | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| tomcat_global_request_seconds_count | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| tomcat_global_request_seconds_sum | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| tomcat_global_sent_bytes_total | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| tomcat_servlet_error_total | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| tomcat_servlet_request_max_seconds | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| tomcat_servlet_request_seconds_count | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| tomcat_servlet_request_seconds_sum | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| tomcat_threads_busy_threads | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| tomcat_threads_config_max_threads | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| tomcat_threads_current_threads | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| jvm_classes_loaded_classes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| jvm_classes_unloaded_classes_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| jvm_gc_live_data_size_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| jvm_gc_max_data_size_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| jvm_gc_memory_allocated_bytes_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| jvm_gc_memory_promoted_bytes_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| jvm_threads_daemon_threads | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| jvm_threads_live_threads | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| jvm_threads_peak_threads | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| process_cpu_usage | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| process_files_max_files | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| process_files_open_files | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| process_start_time_seconds | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| process_uptime_seconds | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| spring_integration_channels | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| spring_integration_handlers | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| spring_integration_sources | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| system_cpu_count | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| system_cpu_usage | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| system_load_average_1m | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| tomcat_cache_access_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| tomcat_cache_hit_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| tomcat_sessions_active_current_sessions | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| tomcat_sessions_active_max_sessions | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| tomcat_sessions_alive_max_seconds | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| tomcat_sessions_created_sessions_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| tomcat_sessions_expired_sessions_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| tomcat_sessions_rejected_sessions_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| zipkin_reporter_messages_bytes_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| zipkin_reporter_messages_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| zipkin_reporter_queue_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| zipkin_reporter_queue_spans | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| zipkin_reporter_spans_bytes_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| zipkin_reporter_spans_dropped_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| zipkin_reporter_spans_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |

</details>
</details>

## By Metric
This table lists the dimensions associated with each metric.
<details>
  <summary>Metrics</summary>

| Metric | Dimensions | Source |
| ------ | ---------- | ------ |
| arke_client_active_messages | ClientIdentitifer,<br>ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| arke_client_active_messages | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| arke_client_consumed_total | ClientIdentitifer,<br>ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| arke_client_consumed_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| arke_client_produced_total | ClientIdentitifer,<br>ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| arke_client_produced_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| arke_client_streams | ClientIdentitifer,<br>ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| arke_client_streams | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| arke_recvmsg_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| arke_recvmsg_total | ClusterName,<br>job,<br>method,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service,<br>status | SAS Go Microservices |
| arke_request_elapsed | ClusterName,<br>job,<br>method,<br>namespace,<br>node,<br>pod,<br>quantile,<br>sas_service_base,<br>service,<br>status | SAS Go Microservices |
| arke_request_elapsed_count | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| arke_request_elapsed_count | ClusterName,<br>job,<br>method,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service,<br>status | SAS Go Microservices |
| arke_request_elapsed_sum | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| arke_request_elapsed_sum | ClusterName,<br>job,<br>method,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service,<br>status | SAS Go Microservices |
| arke_request_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| arke_request_total | ClusterName,<br>job,<br>method,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service,<br>status | SAS Go Microservices |
| arke_sendmsg_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| arke_sendmsg_total | ClusterName,<br>job,<br>method,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service,<br>status | SAS Go Microservices |
| cas_grid_idle_seconds | ClusterName,<br>cas_server,<br>job,<br>namespace,<br>pod | CAS |
| cas_grid_sessions_created_total | ClusterName,<br>cas_server,<br>job,<br>namespace,<br>pod | CAS |
| cas_grid_sessions_current | ClusterName,<br>cas_server,<br>job,<br>namespace,<br>pod | CAS |
| cas_grid_sessions_max | ClusterName,<br>cas_server,<br>job,<br>namespace,<br>pod | CAS |
| cas_grid_start_time_seconds | ClusterName,<br>cas_server,<br>job,<br>namespace,<br>pod | CAS |
| cas_grid_state | ClusterName,<br>cas_server,<br>job,<br>namespace,<br>pod,<br>state | CAS |
| cas_grid_uptime_seconds_total | ClusterName,<br>cas_server,<br>job,<br>namespace,<br>pod | CAS |
| cas_node_cpu_time_seconds | ClusterName,<br>cas_node,<br>cas_node_type,<br>cas_server,<br>job,<br>namespace,<br>pod,<br>type | CAS |
| cas_node_fifteen_minute_cpu_load_avg | ClusterName,<br>cas_node,<br>cas_node_type,<br>cas_server,<br>job,<br>namespace,<br>pod | CAS |
| cas_node_five_minute_cpu_load_avg | ClusterName,<br>cas_node,<br>cas_node_type,<br>cas_server,<br>job,<br>namespace,<br>pod | CAS |
| cas_node_free_files | ClusterName,<br>cas_node,<br>cas_node_type,<br>cas_server,<br>job,<br>namespace,<br>pod | CAS |
| cas_node_inodes_free | ClusterName,<br>cas_node,<br>cas_node_type,<br>cas_server,<br>job,<br>namespace,<br>pod | CAS |
| cas_node_inodes_used | ClusterName,<br>cas_node,<br>cas_node_type,<br>cas_server,<br>job,<br>namespace,<br>pod | CAS |
| cas_node_max_open_files | ClusterName,<br>cas_node,<br>cas_node_type,<br>cas_server,<br>job,<br>namespace,<br>pod | CAS |
| cas_node_mem_free_bytes | ClusterName,<br>cas_node,<br>cas_node_type,<br>cas_server,<br>job,<br>namespace,<br>pod,<br>type | CAS |
| cas_node_mem_size_bytes | ClusterName,<br>cas_node,<br>cas_node_type,<br>cas_server,<br>job,<br>namespace,<br>pod,<br>type | CAS |
| cas_node_one_minute_cpu_load_avg | ClusterName,<br>cas_node,<br>cas_node_type,<br>cas_server,<br>job,<br>namespace,<br>pod | CAS |
| cas_node_open_files | ClusterName,<br>cas_node,<br>cas_node_type,<br>cas_server,<br>job,<br>namespace,<br>pod | CAS |
| cas_nodes | ClusterName,<br>cas_node,<br>cas_node_type,<br>cas_server,<br>connected,<br>job,<br>namespace,<br>pod,<br>uuid | CAS |
| ccp_archive_command_status_seconds_since_last_fail | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_backrest_last_diff_backup_time_since_completion_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service,<br>stanza | Postgres |
| ccp_backrest_last_full_backup_time_since_completion_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service,<br>stanza | Postgres |
| ccp_backrest_last_incr_backup_time_since_completion_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service,<br>stanza | Postgres |
| ccp_backrest_last_info_backup_runtime_seconds | ClusterName,<br>backup_type,<br>job,<br>namespace,<br>pod,<br>server,<br>service,<br>stanza | Postgres |
| ccp_backrest_last_info_repo_backup_size_bytes | ClusterName,<br>backup_type,<br>job,<br>namespace,<br>pod,<br>server,<br>service,<br>stanza | Postgres |
| ccp_backrest_last_info_repo_total_size_bytes | ClusterName,<br>backup_type,<br>job,<br>namespace,<br>pod,<br>server,<br>service,<br>stanza | Postgres |
| ccp_connection_stats_active | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_connection_stats_idle | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_connection_stats_idle_in_txn | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_connection_stats_max_blocked_query_time | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_connection_stats_max_connections | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_connection_stats_max_idle_in_txn_time | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_connection_stats_max_query_time | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_connection_stats_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_data_checksum_failure_time_since_last_failure_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_data_checksum_failure_time_since_last_failure_seconds | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_database_size_bytes | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_is_in_recovery_status | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_locks_count | ClusterName,<br>dbname,<br>job,<br>mode,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_nodemx_cpu_limit | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_nodemx_cpu_request | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_nodemx_cpuacct_usage | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_nodemx_cpucfs_period_us | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_nodemx_cpucfs_quota_us | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_nodemx_cpustat_nr_periods | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_nodemx_cpustat_nr_throttled | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_nodemx_cpustat_throttled_time | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_nodemx_data_disk_available_bytes | ClusterName,<br>fs_type,<br>job,<br>mount_point,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_nodemx_data_disk_free_file_nodes | ClusterName,<br>fs_type,<br>job,<br>mount_point,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_nodemx_data_disk_total_bytes | ClusterName,<br>fs_type,<br>job,<br>mount_point,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_nodemx_data_disk_total_file_nodes | ClusterName,<br>fs_type,<br>job,<br>mount_point,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_nodemx_disk_activity_sectors_read | ClusterName,<br>job,<br>mount_point,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_nodemx_disk_activity_sectors_written | ClusterName,<br>job,<br>mount_point,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_nodemx_mem_active_anon | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_nodemx_mem_active_file | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_nodemx_mem_cache | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_nodemx_mem_inactive_anon | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_nodemx_mem_inactive_file | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_nodemx_mem_limit | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_nodemx_mem_mapped_file | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_nodemx_mem_request | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_nodemx_mem_rss | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_nodemx_network_rx_bytes | ClusterName,<br>interface,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_nodemx_network_rx_packets | ClusterName,<br>interface,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_nodemx_network_tx_bytes | ClusterName,<br>interface,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_nodemx_network_tx_packets | ClusterName,<br>interface,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_nodemx_process_count | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_pg_hba_checksum_status | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_pg_settings_checksum_status | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_postgresql_version_current | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_postmaster_runtime_start_time_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_postmaster_uptime_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_replication_lag_size_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>replica,<br>replica_port,<br>server,<br>service | Postgres |
| ccp_sequence_exhaustion_count | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_settings_gauge_checkpoint_completion_target | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_settings_gauge_checkpoint_timeout | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_settings_gauge_shared_buffers | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_settings_pending_restart_count | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_stat_bgwriter_buffers_alloc | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_stat_bgwriter_buffers_backend | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_stat_bgwriter_buffers_backend_fsync | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_stat_bgwriter_buffers_checkpoint | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_stat_bgwriter_buffers_clean | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_stat_bgwriter_checkpoint_sync_time | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_stat_bgwriter_checkpoint_write_time | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_stat_bgwriter_checkpoints_req | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_stat_bgwriter_checkpoints_timed | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_stat_bgwriter_maxwritten_clean | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_stat_bgwriter_stats_reset | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_stat_database_blks_hit | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_stat_database_blks_read | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_stat_database_conflicts | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_stat_database_deadlocks | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_stat_database_temp_bytes | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_stat_database_temp_files | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_stat_database_tup_deleted | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_stat_database_tup_fetched | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_stat_database_tup_inserted | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_stat_database_tup_returned | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_stat_database_tup_updated | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_stat_database_xact_commit | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_stat_database_xact_rollback | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_stat_user_tables_analyze_count | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>relname,<br>schemaname,<br>server,<br>service | Postgres |
| ccp_stat_user_tables_autoanalyze_count | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>relname,<br>schemaname,<br>server,<br>service | Postgres |
| ccp_stat_user_tables_autovacuum_count | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>relname,<br>schemaname,<br>server,<br>service | Postgres |
| ccp_stat_user_tables_idx_scan | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>relname,<br>schemaname,<br>server,<br>service | Postgres |
| ccp_stat_user_tables_idx_tup_fetch | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>relname,<br>schemaname,<br>server,<br>service | Postgres |
| ccp_stat_user_tables_n_dead_tup | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>relname,<br>schemaname,<br>server,<br>service | Postgres |
| ccp_stat_user_tables_n_live_tup | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>relname,<br>schemaname,<br>server,<br>service | Postgres |
| ccp_stat_user_tables_n_tup_del | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>relname,<br>schemaname,<br>server,<br>service | Postgres |
| ccp_stat_user_tables_n_tup_hot_upd | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>relname,<br>schemaname,<br>server,<br>service | Postgres |
| ccp_stat_user_tables_n_tup_ins | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>relname,<br>schemaname,<br>server,<br>service | Postgres |
| ccp_stat_user_tables_n_tup_upd | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>relname,<br>schemaname,<br>server,<br>service | Postgres |
| ccp_stat_user_tables_seq_scan | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>relname,<br>schemaname,<br>server,<br>service | Postgres |
| ccp_stat_user_tables_seq_tup_read | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>relname,<br>schemaname,<br>server,<br>service | Postgres |
| ccp_stat_user_tables_vacuum_count | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>relname,<br>schemaname,<br>server,<br>service | Postgres |
| ccp_table_size_size_bytes | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>relname,<br>schemaname,<br>server,<br>service | Postgres |
| ccp_transaction_wraparound_oldest_current_xid | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_transaction_wraparound_percent_towards_emergency_autovac | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_transaction_wraparound_percent_towards_wraparound | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_wal_activity_last_5_min_size_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| ccp_wal_activity_total_size_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| erlang_mnesia_committed_transactions | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| erlang_mnesia_failed_transactions | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| erlang_mnesia_held_locks | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| erlang_mnesia_lock_queue | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| erlang_mnesia_logged_transactions | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| erlang_mnesia_restarted_transactions | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| erlang_mnesia_transaction_coordinators | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| erlang_mnesia_transaction_participants | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| erlang_vm_allocators | ClusterName,<br>alloc,<br>instance_no,<br>job,<br>kind,<br>namespace,<br>pod,<br>service,<br>usage | RabbitMQ |
| erlang_vm_atom_count | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| erlang_vm_atom_limit | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| erlang_vm_dirty_cpu_schedulers | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| erlang_vm_dirty_cpu_schedulers_online | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| erlang_vm_dirty_io_schedulers | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| erlang_vm_dist_node_queue_size_bytes | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service | RabbitMQ |
| erlang_vm_dist_node_state | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service | RabbitMQ |
| erlang_vm_dist_port_input_bytes | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service | RabbitMQ |
| erlang_vm_dist_port_memory_bytes | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service | RabbitMQ |
| erlang_vm_dist_port_output_bytes | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service | RabbitMQ |
| erlang_vm_dist_port_queue_size_bytes | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service | RabbitMQ |
| erlang_vm_dist_proc_heap_size_words | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service,<br>type | RabbitMQ |
| erlang_vm_dist_proc_memory_bytes | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service,<br>type | RabbitMQ |
| erlang_vm_dist_proc_message_queue_len | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service,<br>type | RabbitMQ |
| erlang_vm_dist_proc_min_bin_vheap_size_words | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service,<br>type | RabbitMQ |
| erlang_vm_dist_proc_min_heap_size_words | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service,<br>type | RabbitMQ |
| erlang_vm_dist_proc_reductions | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service,<br>type | RabbitMQ |
| erlang_vm_dist_proc_stack_size_words | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service,<br>type | RabbitMQ |
| erlang_vm_dist_proc_status | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service,<br>type | RabbitMQ |
| erlang_vm_dist_proc_total_heap_size_words | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service,<br>type | RabbitMQ |
| erlang_vm_dist_recv_avg_bytes | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service | RabbitMQ |
| erlang_vm_dist_recv_bytes | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service | RabbitMQ |
| erlang_vm_dist_recv_cnt | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service | RabbitMQ |
| erlang_vm_dist_recv_dvi_bytes | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service | RabbitMQ |
| erlang_vm_dist_recv_max_bytes | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service | RabbitMQ |
| erlang_vm_dist_send_avg_bytes | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service | RabbitMQ |
| erlang_vm_dist_send_bytes | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service | RabbitMQ |
| erlang_vm_dist_send_cnt | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service | RabbitMQ |
| erlang_vm_dist_send_max_bytes | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service | RabbitMQ |
| erlang_vm_dist_send_pend_bytes | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service | RabbitMQ |
| erlang_vm_ets_limit | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| erlang_vm_logical_processors | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| erlang_vm_logical_processors_available | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| erlang_vm_logical_processors_online | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| erlang_vm_memory_atom_bytes_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service,<br>usage | RabbitMQ |
| erlang_vm_memory_bytes_total | ClusterName,<br>job,<br>kind,<br>namespace,<br>pod,<br>service | RabbitMQ |
| erlang_vm_memory_dets_tables | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| erlang_vm_memory_ets_tables | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| erlang_vm_memory_processes_bytes_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service,<br>usage | RabbitMQ |
| erlang_vm_memory_system_bytes_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service,<br>usage | RabbitMQ |
| erlang_vm_msacc_alloc_seconds_total | ClusterName,<br>id,<br>job,<br>namespace,<br>pod,<br>service,<br>type | RabbitMQ |
| erlang_vm_msacc_aux_seconds_total | ClusterName,<br>id,<br>job,<br>namespace,<br>pod,<br>service,<br>type | RabbitMQ |
| erlang_vm_msacc_bif_seconds_total | ClusterName,<br>id,<br>job,<br>namespace,<br>pod,<br>service,<br>type | RabbitMQ |
| erlang_vm_msacc_busy_wait_seconds_total | ClusterName,<br>id,<br>job,<br>namespace,<br>pod,<br>service,<br>type | RabbitMQ |
| erlang_vm_msacc_check_io_seconds_total | ClusterName,<br>id,<br>job,<br>namespace,<br>pod,<br>service,<br>type | RabbitMQ |
| erlang_vm_msacc_emulator_seconds_total | ClusterName,<br>id,<br>job,<br>namespace,<br>pod,<br>service,<br>type | RabbitMQ |
| erlang_vm_msacc_ets_seconds_total | ClusterName,<br>id,<br>job,<br>namespace,<br>pod,<br>service,<br>type | RabbitMQ |
| erlang_vm_msacc_gc_full_seconds_total | ClusterName,<br>id,<br>job,<br>namespace,<br>pod,<br>service,<br>type | RabbitMQ |
| erlang_vm_msacc_gc_seconds_total | ClusterName,<br>id,<br>job,<br>namespace,<br>pod,<br>service,<br>type | RabbitMQ |
| erlang_vm_msacc_nif_seconds_total | ClusterName,<br>id,<br>job,<br>namespace,<br>pod,<br>service,<br>type | RabbitMQ |
| erlang_vm_msacc_other_seconds_total | ClusterName,<br>id,<br>job,<br>namespace,<br>pod,<br>service,<br>type | RabbitMQ |
| erlang_vm_msacc_port_seconds_total | ClusterName,<br>id,<br>job,<br>namespace,<br>pod,<br>service,<br>type | RabbitMQ |
| erlang_vm_msacc_send_seconds_total | ClusterName,<br>id,<br>job,<br>namespace,<br>pod,<br>service,<br>type | RabbitMQ |
| erlang_vm_msacc_sleep_seconds_total | ClusterName,<br>id,<br>job,<br>namespace,<br>pod,<br>service,<br>type | RabbitMQ |
| erlang_vm_msacc_timers_seconds_total | ClusterName,<br>id,<br>job,<br>namespace,<br>pod,<br>service,<br>type | RabbitMQ |
| erlang_vm_port_count | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| erlang_vm_port_limit | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| erlang_vm_process_count | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| erlang_vm_process_limit | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| erlang_vm_schedulers | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| erlang_vm_schedulers_online | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| erlang_vm_smp_support | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| erlang_vm_statistics_bytes_output_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| erlang_vm_statistics_bytes_received_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| erlang_vm_statistics_context_switches | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| erlang_vm_statistics_dirty_cpu_run_queue_length | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| erlang_vm_statistics_dirty_io_run_queue_length | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| erlang_vm_statistics_garbage_collection_bytes_reclaimed | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| erlang_vm_statistics_garbage_collection_number_of_gcs | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| erlang_vm_statistics_garbage_collection_words_reclaimed | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| erlang_vm_statistics_reductions_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| erlang_vm_statistics_run_queues_length_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| erlang_vm_statistics_runtime_milliseconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| erlang_vm_statistics_wallclock_time_milliseconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| erlang_vm_thread_pool_size | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| erlang_vm_threads | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| erlang_vm_time_correction | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| erlang_vm_wordsize_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| go_gc_duration_seconds | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>quantile,<br>sas_service_base,<br>service | SAS Go Microservices |
| go_gc_duration_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>quantile,<br>service | Postgres |
| go_gc_duration_seconds_count | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| go_gc_duration_seconds_count | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | Postgres |
| go_gc_duration_seconds_sum | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| go_gc_duration_seconds_sum | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | Postgres |
| go_goroutines | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| go_goroutines | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | Postgres |
| go_memstats_alloc_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| go_memstats_alloc_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | Postgres |
| go_memstats_alloc_bytes_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| go_memstats_alloc_bytes_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | Postgres |
| go_memstats_buck_hash_sys_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| go_memstats_buck_hash_sys_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | Postgres |
| go_memstats_frees_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| go_memstats_frees_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | Postgres |
| go_memstats_gc_cpu_fraction | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| go_memstats_gc_cpu_fraction | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | Postgres |
| go_memstats_gc_sys_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| go_memstats_gc_sys_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | Postgres |
| go_memstats_heap_alloc_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| go_memstats_heap_alloc_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | Postgres |
| go_memstats_heap_idle_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| go_memstats_heap_idle_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | Postgres |
| go_memstats_heap_inuse_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| go_memstats_heap_inuse_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | Postgres |
| go_memstats_heap_objects | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| go_memstats_heap_objects | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | Postgres |
| go_memstats_heap_released_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| go_memstats_heap_released_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | Postgres |
| go_memstats_heap_sys_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| go_memstats_heap_sys_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | Postgres |
| go_memstats_last_gc_time_seconds | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| go_memstats_last_gc_time_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | Postgres |
| go_memstats_lookups_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| go_memstats_lookups_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | Postgres |
| go_memstats_mallocs_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| go_memstats_mallocs_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | Postgres |
| go_memstats_mcache_inuse_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| go_memstats_mcache_inuse_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | Postgres |
| go_memstats_mcache_sys_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| go_memstats_mcache_sys_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | Postgres |
| go_memstats_mspan_inuse_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| go_memstats_mspan_inuse_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | Postgres |
| go_memstats_mspan_sys_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| go_memstats_mspan_sys_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | Postgres |
| go_memstats_next_gc_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| go_memstats_next_gc_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | Postgres |
| go_memstats_other_sys_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| go_memstats_other_sys_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | Postgres |
| go_memstats_stack_inuse_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| go_memstats_stack_inuse_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | Postgres |
| go_memstats_stack_sys_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| go_memstats_stack_sys_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | Postgres |
| go_memstats_sys_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| go_memstats_sys_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | Postgres |
| go_threads | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| go_threads | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | Postgres |
| http_client_requests_seconds_count | ClusterName,<br>job,<br>method,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>status,<br>uri | SAS Java Microservices |
| http_client_requests_seconds_max | ClusterName,<br>job,<br>method,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>status,<br>uri | SAS Java Microservices |
| http_client_requests_seconds_sum | ClusterName,<br>job,<br>method,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>status,<br>uri | SAS Java Microservices |
| http_server_requests_seconds_count | ClusterName,<br>job,<br>method,<br>namespace,<br>node,<br>outcome,<br>pod,<br>sas_service_base,<br>status,<br>uri | SAS Java Microservices |
| http_server_requests_seconds_max | ClusterName,<br>job,<br>method,<br>namespace,<br>node,<br>outcome,<br>pod,<br>sas_service_base,<br>status,<br>uri | SAS Java Microservices |
| http_server_requests_seconds_sum | ClusterName,<br>job,<br>method,<br>namespace,<br>node,<br>outcome,<br>pod,<br>sas_service_base,<br>status,<br>uri | SAS Java Microservices |
| jdbc_connections_active | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| jdbc_connections_idle | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| jdbc_connections_max | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| jdbc_connections_min | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| jvm_buffer_count_buffers | ClusterName,<br>id,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| jvm_buffer_memory_used_bytes | ClusterName,<br>id,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| jvm_buffer_total_capacity_bytes | ClusterName,<br>id,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| jvm_classes_loaded_classes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| jvm_classes_unloaded_classes_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| jvm_gc_live_data_size_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| jvm_gc_max_data_size_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| jvm_gc_memory_allocated_bytes_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| jvm_gc_memory_promoted_bytes_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| jvm_gc_pause_seconds_count | ClusterName,<br>action,<br>cause,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| jvm_gc_pause_seconds_max | ClusterName,<br>action,<br>cause,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| jvm_gc_pause_seconds_sum | ClusterName,<br>action,<br>cause,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| jvm_memory_committed_bytes | ClusterName,<br>area,<br>id,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| jvm_memory_max_bytes | ClusterName,<br>area,<br>id,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| jvm_memory_used_bytes | ClusterName,<br>area,<br>id,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| jvm_threads_daemon_threads | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| jvm_threads_live_threads | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| jvm_threads_peak_threads | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| jvm_threads_states_threads | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>state | SAS Java Microservices |
| log_events_total | ClusterName,<br>job,<br>level,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| log_events_total | ClusterName,<br>job,<br>level,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| pg_exporter_last_scrape_duration_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | Postgres |
| pg_exporter_last_scrape_error | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | Postgres |
| pg_exporter_scrapes_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | Postgres |
| pg_exporter_user_queries_load_error | ClusterName,<br>filename,<br>hashsum,<br>job,<br>namespace,<br>pod,<br>service | Postgres |
| pg_locks_count | ClusterName,<br>datname,<br>job,<br>mode,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_allow_system_table_mods | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_archive_timeout_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_array_nulls | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_authentication_timeout_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_autovacuum | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_autovacuum_analyze_scale_factor | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_autovacuum_analyze_threshold | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_autovacuum_freeze_max_age | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_autovacuum_max_workers | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_autovacuum_multixact_freeze_max_age | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_autovacuum_naptime_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_autovacuum_vacuum_cost_delay_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_autovacuum_vacuum_cost_limit | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_autovacuum_vacuum_scale_factor | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_autovacuum_vacuum_threshold | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_autovacuum_work_mem_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_backend_flush_after_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_bgwriter_delay_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_bgwriter_flush_after_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_bgwriter_lru_maxpages | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_bgwriter_lru_multiplier | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_block_size | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_bonjour | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_check_function_bodies | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_checkpoint_completion_target | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_checkpoint_flush_after_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_checkpoint_timeout_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_checkpoint_warning_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_commit_delay | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_commit_siblings | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_cpu_index_tuple_cost | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_cpu_operator_cost | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_cpu_tuple_cost | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_cursor_tuple_fraction | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_data_checksums | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_data_directory_mode | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_data_sync_retry | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_db_user_namespace | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_deadlock_timeout_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_debug_assertions | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_debug_pretty_print | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_debug_print_parse | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_debug_print_plan | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_debug_print_rewritten | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_default_statistics_target | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_default_transaction_deferrable | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_default_transaction_read_only | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_effective_cache_size_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_effective_io_concurrency | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_enable_bitmapscan | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_enable_gathermerge | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_enable_hashagg | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_enable_hashjoin | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_enable_indexonlyscan | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_enable_indexscan | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_enable_material | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_enable_mergejoin | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_enable_nestloop | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_enable_parallel_append | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_enable_parallel_hash | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_enable_partition_pruning | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_enable_partitionwise_aggregate | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_enable_partitionwise_join | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_enable_seqscan | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_enable_sort | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_enable_tidscan | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_escape_string_warning | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_exit_on_error | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_extra_float_digits | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_from_collapse_limit | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_fsync | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_full_page_writes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_geqo | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_geqo_effort | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_geqo_generations | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_geqo_pool_size | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_geqo_seed | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_geqo_selection_bias | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_geqo_threshold | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_gin_fuzzy_search_limit | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_gin_pending_list_limit_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_hot_standby | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_hot_standby_feedback | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_idle_in_transaction_session_timeout_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_ignore_checksum_failure | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_ignore_system_indexes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_integer_datetimes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_jit | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_jit_above_cost | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_jit_debugging_support | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_jit_dump_bitcode | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_jit_expressions | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_jit_inline_above_cost | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_jit_optimize_above_cost | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_jit_profiling_support | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_jit_tuple_deforming | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_join_collapse_limit | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_krb_caseins_users | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_lo_compat_privileges | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_lock_timeout_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_log_autovacuum_min_duration_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_log_checkpoints | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_log_connections | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_log_disconnections | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_log_duration | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_log_executor_stats | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_log_file_mode | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_log_hostname | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_log_lock_waits | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_log_min_duration_statement_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_log_parser_stats | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_log_planner_stats | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_log_replication_commands | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_log_rotation_age_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_log_rotation_size_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_log_statement_stats | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_log_temp_files_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_log_transaction_sample_rate | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_log_truncate_on_rotation | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_logging_collector | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_maintenance_work_mem_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_max_connections | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_max_files_per_process | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_max_function_args | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_max_identifier_length | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_max_index_keys | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_max_locks_per_transaction | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_max_logical_replication_workers | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_max_parallel_maintenance_workers | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_max_parallel_workers | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_max_parallel_workers_per_gather | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_max_pred_locks_per_page | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_max_pred_locks_per_relation | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_max_pred_locks_per_transaction | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_max_prepared_transactions | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_max_replication_slots | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_max_stack_depth_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_max_standby_archive_delay_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_max_standby_streaming_delay_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_max_sync_workers_per_subscription | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_max_wal_senders | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_max_wal_size_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_max_worker_processes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_min_parallel_index_scan_size_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_min_parallel_table_scan_size_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_min_wal_size_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_old_snapshot_threshold_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_operator_precedence_warning | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_parallel_leader_participation | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_parallel_setup_cost | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_parallel_tuple_cost | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_pg_stat_statements_max | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_pg_stat_statements_save | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_pg_stat_statements_track_utility | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_pgaudit_log_catalog | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_pgaudit_log_client | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_pgaudit_log_parameter | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_pgaudit_log_relation | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_pgaudit_log_statement_once | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_pgnodemx_cgroup_enabled | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_pgnodemx_containerized | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_pgnodemx_kdapi_enabled | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_plpgsql_check_asserts | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_plpgsql_print_strict_params | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_port | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_post_auth_delay_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_pre_auth_delay_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_quote_all_identifiers | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_random_page_cost | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_recovery_min_apply_delay_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_recovery_target_inclusive | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_restart_after_crash | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_row_security | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_segment_size_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_seq_page_cost | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_server_version_num | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_shared_buffers_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_ssl | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_ssl_passphrase_command_supports_reload | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_ssl_prefer_server_ciphers | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_standard_conforming_strings | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_statement_timeout_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_superuser_reserved_connections | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_synchronize_seqscans | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_syslog_sequence_numbers | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_syslog_split_messages | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_tcp_keepalives_count | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_tcp_keepalives_idle_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_tcp_keepalives_interval_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_tcp_user_timeout_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_temp_buffers_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_temp_file_limit_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_trace_notify | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_trace_sort | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_track_activities | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_track_activity_query_size_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_track_commit_timestamp | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_track_counts | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_track_io_timing | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_transaction_deferrable | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_transaction_read_only | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_transform_null_equals | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_unix_socket_permissions | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_update_process_title | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_vacuum_cleanup_index_scale_factor | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_vacuum_cost_delay_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_vacuum_cost_limit | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_vacuum_cost_page_dirty | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_vacuum_cost_page_hit | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_vacuum_cost_page_miss | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_vacuum_defer_cleanup_age | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_vacuum_freeze_min_age | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_vacuum_freeze_table_age | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_vacuum_multixact_freeze_min_age | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_vacuum_multixact_freeze_table_age | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_wal_block_size | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_wal_buffers_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_wal_compression | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_wal_init_zero | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_wal_keep_segments | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_wal_log_hints | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_wal_receiver_status_interval_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_wal_receiver_timeout_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_wal_recycle | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_wal_retrieve_retry_interval_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_wal_segment_size_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_wal_sender_timeout_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_wal_writer_delay_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_wal_writer_flush_after_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_work_mem_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_settings_zero_damaged_pages | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_activity_count | ClusterName,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service,<br>state | Postgres |
| pg_stat_activity_max_tx_duration | ClusterName,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service,<br>state | Postgres |
| pg_stat_archiver_archived_count | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_archiver_failed_count | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_archiver_last_archive_age | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_bgwriter_buffers_alloc | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_bgwriter_buffers_backend | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_bgwriter_buffers_backend_fsync | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_bgwriter_buffers_checkpoint | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_bgwriter_buffers_clean | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_bgwriter_checkpoint_sync_time | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_bgwriter_checkpoint_write_time | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_bgwriter_checkpoints_req | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_bgwriter_checkpoints_timed | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_bgwriter_maxwritten_clean | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_bgwriter_stats_reset | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_database_blk_read_time | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_database_blk_read_time | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_database_blk_write_time | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_database_blk_write_time | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_database_blks_hit | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_database_blks_hit | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_database_blks_read | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_database_blks_read | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_database_conflicts | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_database_conflicts | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_database_conflicts_confl_bufferpin | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_database_conflicts_confl_deadlock | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_database_conflicts_confl_lock | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_database_conflicts_confl_snapshot | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_database_conflicts_confl_tablespace | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_database_deadlocks | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_database_deadlocks | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_database_numbackends | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_database_numbackends | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_database_stats_reset | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_database_stats_reset | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_database_temp_bytes | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_database_temp_bytes | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_database_temp_files | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_database_temp_files | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_database_tup_deleted | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_database_tup_deleted | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_database_tup_fetched | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_database_tup_fetched | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_database_tup_inserted | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_database_tup_inserted | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_database_tup_returned | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_database_tup_returned | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_database_tup_updated | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_database_tup_updated | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_database_xact_commit | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_database_xact_commit | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_database_xact_rollback | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_stat_database_xact_rollback | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service | Postgres |
| pg_static | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service,<br>short_version,<br>version | Postgres |
| pg_up | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | Postgres |
| process_cpu_seconds_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| process_cpu_seconds_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | Postgres |
| process_cpu_usage | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| process_files_max_files | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| process_files_open_files | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| process_max_fds | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| process_max_fds | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | Postgres |
| process_open_fds | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| process_open_fds | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | Postgres |
| process_resident_memory_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| process_resident_memory_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | Postgres |
| process_start_time_seconds | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| process_start_time_seconds | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| process_start_time_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | Postgres |
| process_uptime_seconds | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| process_virtual_memory_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| process_virtual_memory_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | Postgres |
| process_virtual_memory_max_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| process_virtual_memory_max_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | Postgres |
| rabbitmq_acknowledged_published_total | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| rabbitmq_acknowledged_total | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| rabbitmq_auth_attempts_failed_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>protocol,<br>service | RabbitMQ |
| rabbitmq_auth_attempts_succeeded_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>protocol,<br>service | RabbitMQ |
| rabbitmq_auth_attempts_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>protocol,<br>service | RabbitMQ |
| rabbitmq_channel_acks_uncommitted | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_channel_consumers | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_channel_get_ack_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_channel_get_empty_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_channel_get_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_channel_messages_acked_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_channel_messages_confirmed_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_channel_messages_delivered_ack_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_channel_messages_delivered_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_channel_messages_published_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_channel_messages_redelivered_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_channel_messages_unacked | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_channel_messages_uncommitted | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_channel_messages_unconfirmed | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_channel_messages_unroutable_dropped_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_channel_messages_unroutable_returned_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_channel_prefetch | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_channel_process_reductions_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_channels | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| rabbitmq_channels | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_channels_closed_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_channels_opened_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_connection_channels | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_connection_incoming_bytes_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_connection_incoming_packets_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_connection_outgoing_bytes_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_connection_outgoing_packets_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_connection_pending_packets | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_connection_process_reductions_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_connections | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| rabbitmq_connections | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_connections_closed_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_connections_opened_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_consumed_total | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| rabbitmq_consumer_prefetch | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_consumers | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_disk_space_available_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_disk_space_available_limit_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_erlang_gc_reclaimed_bytes_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_erlang_gc_runs_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_erlang_net_ticktime_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_erlang_processes_limit | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_erlang_processes_used | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_erlang_scheduler_context_switches_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_erlang_scheduler_run_queue | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_erlang_uptime_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_failed_to_publish_total | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| rabbitmq_io_open_attempt_ops_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_io_open_attempt_time_seconds_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_io_read_bytes_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_io_read_ops_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_io_read_time_seconds_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_io_reopen_ops_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_io_seek_ops_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_io_seek_time_seconds_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_io_sync_ops_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_io_sync_time_seconds_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_io_write_bytes_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_io_write_ops_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_io_write_time_seconds_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_msg_store_read_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_msg_store_write_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_not_acknowledged_published_total | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| rabbitmq_process_max_fds | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_process_max_tcp_sockets | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_process_open_fds | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_process_open_tcp_sockets | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_process_resident_memory_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_published_total | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| rabbitmq_queue_consumer_utilisation | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_queue_consumers | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_queue_disk_reads_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_queue_disk_writes_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_queue_index_journal_write_ops_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_queue_index_read_ops_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_queue_index_write_ops_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_queue_messages | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_queue_messages_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_queue_messages_paged_out | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_queue_messages_paged_out_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_queue_messages_persistent | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_queue_messages_published_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_queue_messages_ram | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_queue_messages_ram_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_queue_messages_ready | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_queue_messages_ready_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_queue_messages_ready_ram | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_queue_messages_unacked | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_queue_messages_unacked_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_queue_messages_unacked_ram | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_queue_process_memory_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_queue_process_reductions_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_queues | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_queues_created_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_queues_declared_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_queues_deleted_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_raft_entry_commit_latency_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_raft_log_commit_index | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_raft_log_last_applied_index | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_raft_log_last_written_index | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_raft_log_snapshot_index | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_raft_term_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_rejected_total | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| rabbitmq_resident_memory_limit_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_schema_db_disk_tx_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_schema_db_ram_tx_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | RabbitMQ |
| rabbitmq_unrouted_published_total | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| runtime_alloc_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| runtime_free_count | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| runtime_gc_pause_ns_count | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| runtime_gc_pause_ns_sum | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| runtime_heap_objects | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| runtime_malloc_count | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| runtime_num_goroutines | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| runtime_sys_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| runtime_total_gc_pause_ns | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| runtime_total_gc_runs | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| sas_db_closed_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>reason,<br>sas_service_base,<br>service | SAS Go Microservices |
| sas_db_closed_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>reason,<br>sas_service_base,<br>schema,<br>service | SAS Go Microservices |
| sas_db_connections_max | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service,<br>state | SAS Go Microservices |
| sas_db_connections_max | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>schema,<br>service,<br>state | SAS Go Microservices |
| sas_db_pool_connections | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service,<br>state | SAS Go Microservices |
| sas_db_pool_connections | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>schema,<br>service,<br>state | SAS Go Microservices |
| sas_db_wait_seconds | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>schema,<br>service | SAS Go Microservices |
| sas_db_wait_seconds | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| sas_db_wait_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>schema,<br>service | SAS Go Microservices |
| sas_db_wait_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| sas_maps_esri_query_duration_seconds_count | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| sas_maps_esri_query_duration_seconds_sum | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| sas_maps_report_polling_attempts_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| sas_maps_report_query_duration_seconds_count | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| sas_maps_report_query_duration_seconds_sum | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | SAS Go Microservices |
| spring_integration_channels | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| spring_integration_handlers | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| spring_integration_sources | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| spring_rabbitmq_listener_seconds_count | ClusterName,<br>job,<br>listener_id,<br>namespace,<br>node,<br>pod,<br>queue,<br>result,<br>sas_service_base | SAS Java Microservices |
| spring_rabbitmq_listener_seconds_max | ClusterName,<br>job,<br>listener_id,<br>namespace,<br>node,<br>pod,<br>queue,<br>result,<br>sas_service_base | SAS Java Microservices |
| spring_rabbitmq_listener_seconds_sum | ClusterName,<br>job,<br>listener_id,<br>namespace,<br>node,<br>pod,<br>queue,<br>result,<br>sas_service_base | SAS Java Microservices |
| system_cpu_count | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| system_cpu_usage | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| system_load_average_1m | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| telemetry_scrape_duration_seconds_count | ClusterName,<br>content_type,<br>job,<br>namespace,<br>pod,<br>registry,<br>service | RabbitMQ |
| telemetry_scrape_duration_seconds_sum | ClusterName,<br>content_type,<br>job,<br>namespace,<br>pod,<br>registry,<br>service | RabbitMQ |
| telemetry_scrape_encoded_size_bytes_count | ClusterName,<br>content_type,<br>encoding,<br>job,<br>namespace,<br>pod,<br>registry,<br>service | RabbitMQ |
| telemetry_scrape_encoded_size_bytes_sum | ClusterName,<br>content_type,<br>encoding,<br>job,<br>namespace,<br>pod,<br>registry,<br>service | RabbitMQ |
| telemetry_scrape_size_bytes_count | ClusterName,<br>content_type,<br>job,<br>namespace,<br>pod,<br>registry,<br>service | RabbitMQ |
| telemetry_scrape_size_bytes_sum | ClusterName,<br>content_type,<br>job,<br>namespace,<br>pod,<br>registry,<br>service | RabbitMQ |
| tomcat_cache_access_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| tomcat_cache_hit_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| tomcat_global_error_total | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| tomcat_global_received_bytes_total | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| tomcat_global_request_max_seconds | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| tomcat_global_request_seconds_count | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| tomcat_global_request_seconds_sum | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| tomcat_global_sent_bytes_total | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| tomcat_servlet_error_total | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| tomcat_servlet_request_max_seconds | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| tomcat_servlet_request_seconds_count | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| tomcat_servlet_request_seconds_sum | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| tomcat_sessions_active_current_sessions | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| tomcat_sessions_active_max_sessions | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| tomcat_sessions_alive_max_seconds | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| tomcat_sessions_created_sessions_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| tomcat_sessions_expired_sessions_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| tomcat_sessions_rejected_sessions_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| tomcat_threads_busy_threads | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| tomcat_threads_config_max_threads | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| tomcat_threads_current_threads | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| zipkin_reporter_messages_bytes_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| zipkin_reporter_messages_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| zipkin_reporter_queue_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| zipkin_reporter_queue_spans | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| zipkin_reporter_spans_bytes_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| zipkin_reporter_spans_dropped_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |
| zipkin_reporter_spans_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | SAS Java Microservices |

</details>
