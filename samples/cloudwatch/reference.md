# CloudWatch SAS Viya Metrics

## By Dimensions
This table lists the metrics associated with each set of dimensions.
<details>
  <summary>Click to expand</summary>
<hr/>
<details>
  <summary>ClusterName,cas_node,cas_node_type,cas_server,job,namespace,pod (8)</summary>

| Metric | Source |
| ------ | ------ |
| cas_node_fifteen_minute_cpu_load_avg | sas-cas |
| cas_node_five_minute_cpu_load_avg | sas-cas |
| cas_node_free_files | sas-cas |
| cas_node_inodes_free | sas-cas |
| cas_node_inodes_used | sas-cas |
| cas_node_max_open_files | sas-cas |
| cas_node_one_minute_cpu_load_avg | sas-cas |
| cas_node_open_files | sas-cas |

</details>
<hr/>
<details>
  <summary>ClusterName,cas_node,cas_node_type,cas_server,connected,job,namespace,pod,uuid (1)</summary>

| Metric | Source |
| ------ | ------ |
| cas_nodes | sas-cas |

</details>
<hr/>
<details>
  <summary>ClusterName,cas_server,job,namespace,pod (6)</summary>

| Metric | Source |
| ------ | ------ |
| cas_grid_idle_seconds | sas-cas |
| cas_grid_sessions_created_total | sas-cas |
| cas_grid_sessions_current | sas-cas |
| cas_grid_sessions_max | sas-cas |
| cas_grid_start_time_seconds | sas-cas |
| cas_grid_uptime_seconds_total | sas-cas |

</details>
<hr/>
<details>
  <summary>ClusterName,cas_server,job,namespace,pod,state (1)</summary>

| Metric | Source |
| ------ | ------ |
| cas_grid_state | sas-cas |

</details>
<hr/>
<details>
  <summary>ClusterName,cas_node,cas_node_type,cas_server,job,namespace,pod,type (3)</summary>

| Metric | Source |
| ------ | ------ |
| cas_node_cpu_time_seconds | sas-cas |
| cas_node_mem_free_bytes | sas-cas |
| cas_node_mem_size_bytes | sas-cas |

</details>
<hr/>
<details>
  <summary>ClusterName,job,namespace,node,pod,sas_service_base,service (59)</summary>

| Metric | Source |
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

</details>
<hr/>
<details>
  <summary>ClusterName,job,namespace,node,pod,reason,sas_service_base,schema,service (1)</summary>

| Metric | Source |
| ------ | ------ |
| sas_db_closed_total | sas-go |

</details>
<hr/>
<details>
  <summary>ClusterName,job,namespace,node,pod,reason,sas_service_base,service (1)</summary>

| Metric | Source |
| ------ | ------ |
| sas_db_closed_total | sas-go |

</details>
<hr/>
<details>
  <summary>ClusterName,job,namespace,node,pod,sas_service_base,schema,service (2)</summary>

| Metric | Source |
| ------ | ------ |
| sas_db_wait_seconds | sas-go |
| sas_db_wait_total | sas-go |

</details>
<hr/>
<details>
  <summary>ClusterName,job,method,namespace,node,pod,sas_service_base,service,status (5)</summary>

| Metric | Source |
| ------ | ------ |
| arke_recvmsg_total | sas-go |
| arke_request_elapsed_count | sas-go |
| arke_request_elapsed_sum | sas-go |
| arke_request_total | sas-go |
| arke_sendmsg_total | sas-go |

</details>
<hr/>
<details>
  <summary>ClusterName,job,namespace,node,pod,sas_service_base,service,state (2)</summary>

| Metric | Source |
| ------ | ------ |
| sas_db_connections_max | sas-go |
| sas_db_pool_connections | sas-go |

</details>
<hr/>
<details>
  <summary>ClientIdentitifer,ClusterName,job,namespace,node,pod,sas_service_base,service (4)</summary>

| Metric | Source |
| ------ | ------ |
| arke_client_active_messages | sas-go |
| arke_client_consumed_total | sas-go |
| arke_client_produced_total | sas-go |
| arke_client_streams | sas-go |

</details>
<hr/>
<details>
  <summary>ClusterName,job,namespace,node,pod,quantile,sas_service_base,service (1)</summary>

| Metric | Source |
| ------ | ------ |
| go_gc_duration_seconds | sas-go |

</details>
<hr/>
<details>
  <summary>ClusterName,job,level,namespace,node,pod,sas_service_base,service (1)</summary>

| Metric | Source |
| ------ | ------ |
| log_events_total | sas-go |

</details>
<hr/>
<details>
  <summary>ClusterName,job,method,namespace,node,pod,quantile,sas_service_base,service,status (1)</summary>

| Metric | Source |
| ------ | ------ |
| arke_request_elapsed | sas-go |

</details>
<hr/>
<details>
  <summary>ClusterName,job,namespace,node,pod,sas_service_base,schema,service,state (2)</summary>

| Metric | Source |
| ------ | ------ |
| sas_db_connections_max | sas-go |
| sas_db_pool_connections | sas-go |

</details>
<hr/>
<details>
  <summary>ClusterName,job,namespace,node,pod,sas_service_base,state (1)</summary>

| Metric | Source |
| ------ | ------ |
| jvm_threads_states_threads | sas-java |

</details>
<hr/>
<details>
  <summary>ClusterName,job,listener_id,namespace,node,pod,queue,result,sas_service_base (3)</summary>

| Metric | Source |
| ------ | ------ |
| spring_rabbitmq_listener_seconds_count | sas-java |
| spring_rabbitmq_listener_seconds_max | sas-java |
| spring_rabbitmq_listener_seconds_sum | sas-java |

</details>
<hr/>
<details>
  <summary>ClusterName,job,namespace,node,pod,sas_service_base (35)</summary>

| Metric | Source |
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

</details>
<hr/>
<details>
  <summary>ClusterName,action,cause,job,namespace,node,pod,sas_service_base (3)</summary>

| Metric | Source |
| ------ | ------ |
| jvm_gc_pause_seconds_count | sas-java |
| jvm_gc_pause_seconds_max | sas-java |
| jvm_gc_pause_seconds_sum | sas-java |

</details>
<hr/>
<details>
  <summary>ClusterName,job,method,namespace,node,pod,sas_service_base,status,uri (3)</summary>

| Metric | Source |
| ------ | ------ |
| http_client_requests_seconds_count | sas-java |
| http_client_requests_seconds_max | sas-java |
| http_client_requests_seconds_sum | sas-java |

</details>
<hr/>
<details>
  <summary>ClusterName,area,id,job,namespace,node,pod,sas_service_base (3)</summary>

| Metric | Source |
| ------ | ------ |
| jvm_memory_committed_bytes | sas-java |
| jvm_memory_max_bytes | sas-java |
| jvm_memory_used_bytes | sas-java |

</details>
<hr/>
<details>
  <summary>ClusterName,job,level,namespace,node,pod,sas_service_base (1)</summary>

| Metric | Source |
| ------ | ------ |
| log_events_total | sas-java |

</details>
<hr/>
<details>
  <summary>ClusterName,job,name,namespace,node,pod,sas_service_base (27)</summary>

| Metric | Source |
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

</details>
<hr/>
<details>
  <summary>ClusterName,job,method,namespace,node,outcome,pod,sas_service_base,status,uri (3)</summary>

| Metric | Source |
| ------ | ------ |
| http_server_requests_seconds_count | sas-java |
| http_server_requests_seconds_max | sas-java |
| http_server_requests_seconds_sum | sas-java |

</details>
<hr/>
<details>
  <summary>ClusterName,id,job,namespace,node,pod,sas_service_base (3)</summary>

| Metric | Source |
| ------ | ------ |
| jvm_buffer_count_buffers | sas-java |
| jvm_buffer_memory_used_bytes | sas-java |
| jvm_buffer_total_capacity_bytes | sas-java |

</details>
<hr/>
<details>
  <summary>ClusterName,job,namespace,pod,server,service,short_version,version (1)</summary>

| Metric | Source |
| ------ | ------ |
| pg_static | sas-postgres |

</details>
<hr/>
<details>
  <summary>ClusterName,dbname,job,namespace,pod,server,service (15)</summary>

| Metric | Source |
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

</details>
<hr/>
<details>
  <summary>ClusterName,datid,job,namespace,pod,server,service (17)</summary>

| Metric | Source |
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

</details>
<hr/>
<details>
  <summary>ClusterName,datname,job,mode,namespace,pod,server,service (1)</summary>

| Metric | Source |
| ------ | ------ |
| pg_locks_count | sas-postgres |

</details>
<hr/>
<details>
  <summary>ClusterName,datid,datname,job,namespace,pod,server,service (22)</summary>

| Metric | Source |
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

</details>
<hr/>
<details>
  <summary>ClusterName,dbname,job,mode,namespace,pod,server,service (1)</summary>

| Metric | Source |
| ------ | ------ |
| ccp_locks_count | sas-postgres |

</details>
<hr/>
<details>
  <summary>ClusterName,filename,hashsum,job,namespace,pod,service (1)</summary>

| Metric | Source |
| ------ | ------ |
| pg_exporter_user_queries_load_error | sas-postgres |

</details>
<hr/>
<details>
  <summary>ClusterName,datname,job,namespace,pod,server,service,state (2)</summary>

| Metric | Source |
| ------ | ------ |
| pg_stat_activity_count | sas-postgres |
| pg_stat_activity_max_tx_duration | sas-postgres |

</details>
<hr/>
<details>
  <summary>ClusterName,job,mount_point,namespace,pod,server,service (2)</summary>

| Metric | Source |
| ------ | ------ |
| ccp_nodemx_disk_activity_sectors_read | sas-postgres |
| ccp_nodemx_disk_activity_sectors_written | sas-postgres |

</details>
<hr/>
<details>
  <summary>ClusterName,dbname,job,namespace,pod,relname,schemaname,server,service (15)</summary>

| Metric | Source |
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

</details>
<hr/>
<details>
  <summary>ClusterName,job,namespace,pod,service (39)</summary>

| Metric | Source |
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

</details>
<hr/>
<details>
  <summary>ClusterName,fs_type,job,mount_point,namespace,pod,server,service (4)</summary>

| Metric | Source |
| ------ | ------ |
| ccp_nodemx_data_disk_available_bytes | sas-postgres |
| ccp_nodemx_data_disk_free_file_nodes | sas-postgres |
| ccp_nodemx_data_disk_total_bytes | sas-postgres |
| ccp_nodemx_data_disk_total_file_nodes | sas-postgres |

</details>
<hr/>
<details>
  <summary>ClusterName,job,namespace,pod,server,service,stanza (3)</summary>

| Metric | Source |
| ------ | ------ |
| ccp_backrest_last_diff_backup_time_since_completion_seconds | sas-postgres |
| ccp_backrest_last_full_backup_time_since_completion_seconds | sas-postgres |
| ccp_backrest_last_incr_backup_time_since_completion_seconds | sas-postgres |

</details>
<hr/>
<details>
  <summary>ClusterName,job,namespace,pod,quantile,service (1)</summary>

| Metric | Source |
| ------ | ------ |
| go_gc_duration_seconds | sas-postgres |

</details>
<hr/>
<details>
  <summary>ClusterName,job,namespace,pod,replica,replica_port,server,service (1)</summary>

| Metric | Source |
| ------ | ------ |
| ccp_replication_lag_size_bytes | sas-postgres |

</details>
<hr/>
<details>
  <summary>ClusterName,job,namespace,pod,server,service (300)</summary>

| Metric | Source |
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

</details>
<hr/>
<details>
  <summary>ClusterName,backup_type,job,namespace,pod,server,service,stanza (3)</summary>

| Metric | Source |
| ------ | ------ |
| ccp_backrest_last_info_backup_runtime_seconds | sas-postgres |
| ccp_backrest_last_info_repo_backup_size_bytes | sas-postgres |
| ccp_backrest_last_info_repo_total_size_bytes | sas-postgres |

</details>
<hr/>
<details>
  <summary>ClusterName,interface,job,namespace,pod,server,service (4)</summary>

| Metric | Source |
| ------ | ------ |
| ccp_nodemx_network_rx_bytes | sas-postgres |
| ccp_nodemx_network_rx_packets | sas-postgres |
| ccp_nodemx_network_tx_bytes | sas-postgres |
| ccp_nodemx_network_tx_packets | sas-postgres |

</details>
<hr/>
<details>
  <summary>ClusterName,id,job,namespace,pod,service,type (15)</summary>

| Metric | Source |
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

</details>
<hr/>
<details>
  <summary>ClusterName,alloc,instance_no,job,kind,namespace,pod,service,usage (1)</summary>

| Metric | Source |
| ------ | ------ |
| erlang_vm_allocators | sas-rabbitmq |

</details>
<hr/>
<details>
  <summary>ClusterName,job,kind,namespace,pod,service (1)</summary>

| Metric | Source |
| ------ | ------ |
| erlang_vm_memory_bytes_total | sas-rabbitmq |

</details>
<hr/>
<details>
  <summary>ClusterName,job,namespace,peer,pod,service,type (9)</summary>

| Metric | Source |
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

</details>
<hr/>
<details>
  <summary>ClusterName,content_type,encoding,job,namespace,pod,registry,service (2)</summary>

| Metric | Source |
| ------ | ------ |
| telemetry_scrape_encoded_size_bytes_count | sas-rabbitmq |
| telemetry_scrape_encoded_size_bytes_sum | sas-rabbitmq |

</details>
<hr/>
<details>
  <summary>ClusterName,job,namespace,peer,pod,service (16)</summary>

| Metric | Source |
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
<hr/>
<details>
  <summary>ClusterName,job,namespace,pod,service,usage (3)</summary>

| Metric | Source |
| ------ | ------ |
| erlang_vm_memory_atom_bytes_total | sas-rabbitmq |
| erlang_vm_memory_processes_bytes_total | sas-rabbitmq |
| erlang_vm_memory_system_bytes_total | sas-rabbitmq |

</details>
<hr/>
<details>
  <summary>ClusterName,job,namespace,pod,protocol,service (3)</summary>

| Metric | Source |
| ------ | ------ |
| rabbitmq_auth_attempts_failed_total | sas-rabbitmq |
| rabbitmq_auth_attempts_succeeded_total | sas-rabbitmq |
| rabbitmq_auth_attempts_total | sas-rabbitmq |

</details>
<hr/>
<details>
  <summary>ClusterName,content_type,job,namespace,pod,registry,service (4)</summary>

| Metric | Source |
| ------ | ------ |
| telemetry_scrape_duration_seconds_count | sas-rabbitmq |
| telemetry_scrape_duration_seconds_sum | sas-rabbitmq |
| telemetry_scrape_size_bytes_count | sas-rabbitmq |
| telemetry_scrape_size_bytes_sum | sas-rabbitmq |

</details>
<hr/>
<details>
  <summary>ClusterName,job,namespace,pod,service (141)</summary>

| Metric | Source |
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

</details>
</details>

## By Source
This table lists the dimensions and metrics associated with each type of metric source (such as CAS, SAS services written in Go, or SAS services written in Java).
<details>
  <summary>Click to expand</summary>
<hr/>
<details>
  <summary>sas-cas (19)</summary>
<b>sas-cas</b>
<hr/>

|  Metric | Dimensions |
| ---------- | ------ |
| cas_node_fifteen_minute_cpu_load_avg | ClusterName,<br>cas_node,<br>cas_node_type,<br>cas_server,<br>job,<br>namespace,<br>pod |
| cas_node_five_minute_cpu_load_avg | ClusterName,<br>cas_node,<br>cas_node_type,<br>cas_server,<br>job,<br>namespace,<br>pod |
| cas_node_free_files | ClusterName,<br>cas_node,<br>cas_node_type,<br>cas_server,<br>job,<br>namespace,<br>pod |
| cas_node_inodes_free | ClusterName,<br>cas_node,<br>cas_node_type,<br>cas_server,<br>job,<br>namespace,<br>pod |
| cas_node_inodes_used | ClusterName,<br>cas_node,<br>cas_node_type,<br>cas_server,<br>job,<br>namespace,<br>pod |
| cas_node_max_open_files | ClusterName,<br>cas_node,<br>cas_node_type,<br>cas_server,<br>job,<br>namespace,<br>pod |
| cas_node_one_minute_cpu_load_avg | ClusterName,<br>cas_node,<br>cas_node_type,<br>cas_server,<br>job,<br>namespace,<br>pod |
| cas_node_open_files | ClusterName,<br>cas_node,<br>cas_node_type,<br>cas_server,<br>job,<br>namespace,<br>pod |
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

</details>
<hr/>
<details>
  <summary>sas-go (79)</summary>
<b>sas-go</b>
<hr/>

|  Metric | Dimensions |
| ---------- | ------ |
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
| sas_db_closed_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>reason,<br>sas_service_base,<br>schema,<br>service |
| sas_db_closed_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>reason,<br>sas_service_base,<br>service |
| sas_db_wait_seconds | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>schema,<br>service |
| sas_db_wait_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>schema,<br>service |
| arke_recvmsg_total | ClusterName,<br>job,<br>method,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service,<br>status |
| arke_request_elapsed_count | ClusterName,<br>job,<br>method,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service,<br>status |
| arke_request_elapsed_sum | ClusterName,<br>job,<br>method,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service,<br>status |
| arke_request_total | ClusterName,<br>job,<br>method,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service,<br>status |
| arke_sendmsg_total | ClusterName,<br>job,<br>method,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service,<br>status |
| sas_db_connections_max | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service,<br>state |
| sas_db_pool_connections | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service,<br>state |
| arke_client_active_messages | ClientIdentitifer,<br>ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| arke_client_consumed_total | ClientIdentitifer,<br>ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| arke_client_produced_total | ClientIdentitifer,<br>ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| arke_client_streams | ClientIdentitifer,<br>ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| go_gc_duration_seconds | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>quantile,<br>sas_service_base,<br>service |
| log_events_total | ClusterName,<br>job,<br>level,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service |
| arke_request_elapsed | ClusterName,<br>job,<br>method,<br>namespace,<br>node,<br>pod,<br>quantile,<br>sas_service_base,<br>service,<br>status |
| sas_db_connections_max | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>schema,<br>service,<br>state |
| sas_db_pool_connections | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>schema,<br>service,<br>state |

</details>
<hr/>
<details>
  <summary>sas-java (82)</summary>
<b>sas-java</b>
<hr/>

|  Metric | Dimensions |
| ---------- | ------ |
| jvm_threads_states_threads | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>state |
| spring_rabbitmq_listener_seconds_count | ClusterName,<br>job,<br>listener_id,<br>namespace,<br>node,<br>pod,<br>queue,<br>result,<br>sas_service_base |
| spring_rabbitmq_listener_seconds_max | ClusterName,<br>job,<br>listener_id,<br>namespace,<br>node,<br>pod,<br>queue,<br>result,<br>sas_service_base |
| spring_rabbitmq_listener_seconds_sum | ClusterName,<br>job,<br>listener_id,<br>namespace,<br>node,<br>pod,<br>queue,<br>result,<br>sas_service_base |
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
| jvm_gc_pause_seconds_count | ClusterName,<br>action,<br>cause,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| jvm_gc_pause_seconds_max | ClusterName,<br>action,<br>cause,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| jvm_gc_pause_seconds_sum | ClusterName,<br>action,<br>cause,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| http_client_requests_seconds_count | ClusterName,<br>job,<br>method,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>status,<br>uri |
| http_client_requests_seconds_max | ClusterName,<br>job,<br>method,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>status,<br>uri |
| http_client_requests_seconds_sum | ClusterName,<br>job,<br>method,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>status,<br>uri |
| jvm_memory_committed_bytes | ClusterName,<br>area,<br>id,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| jvm_memory_max_bytes | ClusterName,<br>area,<br>id,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| jvm_memory_used_bytes | ClusterName,<br>area,<br>id,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| log_events_total | ClusterName,<br>job,<br>level,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
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
| http_server_requests_seconds_count | ClusterName,<br>job,<br>method,<br>namespace,<br>node,<br>outcome,<br>pod,<br>sas_service_base,<br>status,<br>uri |
| http_server_requests_seconds_max | ClusterName,<br>job,<br>method,<br>namespace,<br>node,<br>outcome,<br>pod,<br>sas_service_base,<br>status,<br>uri |
| http_server_requests_seconds_sum | ClusterName,<br>job,<br>method,<br>namespace,<br>node,<br>outcome,<br>pod,<br>sas_service_base,<br>status,<br>uri |
| jvm_buffer_count_buffers | ClusterName,<br>id,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| jvm_buffer_memory_used_bytes | ClusterName,<br>id,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |
| jvm_buffer_total_capacity_bytes | ClusterName,<br>id,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base |

</details>
<hr/>
<details>
  <summary>sas-postgres (432)</summary>
<b>sas-postgres</b>
<hr/>

|  Metric | Dimensions |
| ---------- | ------ |
| pg_static | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service,<br>short_version,<br>version |
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
| pg_locks_count | ClusterName,<br>datname,<br>job,<br>mode,<br>namespace,<br>pod,<br>server,<br>service |
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
| ccp_locks_count | ClusterName,<br>dbname,<br>job,<br>mode,<br>namespace,<br>pod,<br>server,<br>service |
| pg_exporter_user_queries_load_error | ClusterName,<br>filename,<br>hashsum,<br>job,<br>namespace,<br>pod,<br>service |
| pg_stat_activity_count | ClusterName,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service,<br>state |
| pg_stat_activity_max_tx_duration | ClusterName,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service,<br>state |
| ccp_nodemx_disk_activity_sectors_read | ClusterName,<br>job,<br>mount_point,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_nodemx_disk_activity_sectors_written | ClusterName,<br>job,<br>mount_point,<br>namespace,<br>pod,<br>server,<br>service |
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
| ccp_nodemx_data_disk_available_bytes | ClusterName,<br>fs_type,<br>job,<br>mount_point,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_nodemx_data_disk_free_file_nodes | ClusterName,<br>fs_type,<br>job,<br>mount_point,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_nodemx_data_disk_total_bytes | ClusterName,<br>fs_type,<br>job,<br>mount_point,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_nodemx_data_disk_total_file_nodes | ClusterName,<br>fs_type,<br>job,<br>mount_point,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_backrest_last_diff_backup_time_since_completion_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service,<br>stanza |
| ccp_backrest_last_full_backup_time_since_completion_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service,<br>stanza |
| ccp_backrest_last_incr_backup_time_since_completion_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service,<br>stanza |
| go_gc_duration_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>quantile,<br>service |
| ccp_replication_lag_size_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>replica,<br>replica_port,<br>server,<br>service |
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
| ccp_backrest_last_info_backup_runtime_seconds | ClusterName,<br>backup_type,<br>job,<br>namespace,<br>pod,<br>server,<br>service,<br>stanza |
| ccp_backrest_last_info_repo_backup_size_bytes | ClusterName,<br>backup_type,<br>job,<br>namespace,<br>pod,<br>server,<br>service,<br>stanza |
| ccp_backrest_last_info_repo_total_size_bytes | ClusterName,<br>backup_type,<br>job,<br>namespace,<br>pod,<br>server,<br>service,<br>stanza |
| ccp_nodemx_network_rx_bytes | ClusterName,<br>interface,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_nodemx_network_rx_packets | ClusterName,<br>interface,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_nodemx_network_tx_bytes | ClusterName,<br>interface,<br>job,<br>namespace,<br>pod,<br>server,<br>service |
| ccp_nodemx_network_tx_packets | ClusterName,<br>interface,<br>job,<br>namespace,<br>pod,<br>server,<br>service |

</details>
<hr/>
<details>
  <summary>sas-rabbitmq (195)</summary>
<b>sas-rabbitmq</b>
<hr/>

|  Metric | Dimensions |
| ---------- | ------ |
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
| erlang_vm_allocators | ClusterName,<br>alloc,<br>instance_no,<br>job,<br>kind,<br>namespace,<br>pod,<br>service,<br>usage |
| erlang_vm_memory_bytes_total | ClusterName,<br>job,<br>kind,<br>namespace,<br>pod,<br>service |
| erlang_vm_dist_proc_heap_size_words | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service,<br>type |
| erlang_vm_dist_proc_memory_bytes | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service,<br>type |
| erlang_vm_dist_proc_message_queue_len | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service,<br>type |
| erlang_vm_dist_proc_min_bin_vheap_size_words | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service,<br>type |
| erlang_vm_dist_proc_min_heap_size_words | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service,<br>type |
| erlang_vm_dist_proc_reductions | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service,<br>type |
| erlang_vm_dist_proc_stack_size_words | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service,<br>type |
| erlang_vm_dist_proc_status | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service,<br>type |
| erlang_vm_dist_proc_total_heap_size_words | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service,<br>type |
| telemetry_scrape_encoded_size_bytes_count | ClusterName,<br>content_type,<br>encoding,<br>job,<br>namespace,<br>pod,<br>registry,<br>service |
| telemetry_scrape_encoded_size_bytes_sum | ClusterName,<br>content_type,<br>encoding,<br>job,<br>namespace,<br>pod,<br>registry,<br>service |
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
| erlang_vm_memory_atom_bytes_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service,<br>usage |
| erlang_vm_memory_processes_bytes_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service,<br>usage |
| erlang_vm_memory_system_bytes_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service,<br>usage |
| rabbitmq_auth_attempts_failed_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>protocol,<br>service |
| rabbitmq_auth_attempts_succeeded_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>protocol,<br>service |
| rabbitmq_auth_attempts_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>protocol,<br>service |
| telemetry_scrape_duration_seconds_count | ClusterName,<br>content_type,<br>job,<br>namespace,<br>pod,<br>registry,<br>service |
| telemetry_scrape_duration_seconds_sum | ClusterName,<br>content_type,<br>job,<br>namespace,<br>pod,<br>registry,<br>service |
| telemetry_scrape_size_bytes_count | ClusterName,<br>content_type,<br>job,<br>namespace,<br>pod,<br>registry,<br>service |
| telemetry_scrape_size_bytes_sum | ClusterName,<br>content_type,<br>job,<br>namespace,<br>pod,<br>registry,<br>service |
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

</details>
</details>

## By Metric
This table lists the dimensions associated with each metric.
<details>
  <summary>Click to expand</summary>

| Metric | Dimensions | Source |
| ------ | ---------- | ------ |
| arke_client_active_messages | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| arke_client_active_messages | ClientIdentitifer,<br>ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| arke_client_consumed_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| arke_client_consumed_total | ClientIdentitifer,<br>ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| arke_client_produced_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| arke_client_produced_total | ClientIdentitifer,<br>ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| arke_client_streams | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| arke_client_streams | ClientIdentitifer,<br>ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| arke_recvmsg_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| arke_recvmsg_total | ClusterName,<br>job,<br>method,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service,<br>status | sas-go |
| arke_request_elapsed | ClusterName,<br>job,<br>method,<br>namespace,<br>node,<br>pod,<br>quantile,<br>sas_service_base,<br>service,<br>status | sas-go |
| arke_request_elapsed_count | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| arke_request_elapsed_count | ClusterName,<br>job,<br>method,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service,<br>status | sas-go |
| arke_request_elapsed_sum | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| arke_request_elapsed_sum | ClusterName,<br>job,<br>method,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service,<br>status | sas-go |
| arke_request_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| arke_request_total | ClusterName,<br>job,<br>method,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service,<br>status | sas-go |
| arke_sendmsg_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| arke_sendmsg_total | ClusterName,<br>job,<br>method,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service,<br>status | sas-go |
| cas_grid_idle_seconds | ClusterName,<br>cas_server,<br>job,<br>namespace,<br>pod | sas-cas |
| cas_grid_sessions_created_total | ClusterName,<br>cas_server,<br>job,<br>namespace,<br>pod | sas-cas |
| cas_grid_sessions_current | ClusterName,<br>cas_server,<br>job,<br>namespace,<br>pod | sas-cas |
| cas_grid_sessions_max | ClusterName,<br>cas_server,<br>job,<br>namespace,<br>pod | sas-cas |
| cas_grid_start_time_seconds | ClusterName,<br>cas_server,<br>job,<br>namespace,<br>pod | sas-cas |
| cas_grid_state | ClusterName,<br>cas_server,<br>job,<br>namespace,<br>pod,<br>state | sas-cas |
| cas_grid_uptime_seconds_total | ClusterName,<br>cas_server,<br>job,<br>namespace,<br>pod | sas-cas |
| cas_node_cpu_time_seconds | ClusterName,<br>cas_node,<br>cas_node_type,<br>cas_server,<br>job,<br>namespace,<br>pod,<br>type | sas-cas |
| cas_node_fifteen_minute_cpu_load_avg | ClusterName,<br>cas_node,<br>cas_node_type,<br>cas_server,<br>job,<br>namespace,<br>pod | sas-cas |
| cas_node_five_minute_cpu_load_avg | ClusterName,<br>cas_node,<br>cas_node_type,<br>cas_server,<br>job,<br>namespace,<br>pod | sas-cas |
| cas_node_free_files | ClusterName,<br>cas_node,<br>cas_node_type,<br>cas_server,<br>job,<br>namespace,<br>pod | sas-cas |
| cas_node_inodes_free | ClusterName,<br>cas_node,<br>cas_node_type,<br>cas_server,<br>job,<br>namespace,<br>pod | sas-cas |
| cas_node_inodes_used | ClusterName,<br>cas_node,<br>cas_node_type,<br>cas_server,<br>job,<br>namespace,<br>pod | sas-cas |
| cas_node_max_open_files | ClusterName,<br>cas_node,<br>cas_node_type,<br>cas_server,<br>job,<br>namespace,<br>pod | sas-cas |
| cas_node_mem_free_bytes | ClusterName,<br>cas_node,<br>cas_node_type,<br>cas_server,<br>job,<br>namespace,<br>pod,<br>type | sas-cas |
| cas_node_mem_size_bytes | ClusterName,<br>cas_node,<br>cas_node_type,<br>cas_server,<br>job,<br>namespace,<br>pod,<br>type | sas-cas |
| cas_node_one_minute_cpu_load_avg | ClusterName,<br>cas_node,<br>cas_node_type,<br>cas_server,<br>job,<br>namespace,<br>pod | sas-cas |
| cas_node_open_files | ClusterName,<br>cas_node,<br>cas_node_type,<br>cas_server,<br>job,<br>namespace,<br>pod | sas-cas |
| cas_nodes | ClusterName,<br>cas_node,<br>cas_node_type,<br>cas_server,<br>connected,<br>job,<br>namespace,<br>pod,<br>uuid | sas-cas |
| ccp_archive_command_status_seconds_since_last_fail | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_backrest_last_diff_backup_time_since_completion_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service,<br>stanza | sas-postgres |
| ccp_backrest_last_full_backup_time_since_completion_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service,<br>stanza | sas-postgres |
| ccp_backrest_last_incr_backup_time_since_completion_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service,<br>stanza | sas-postgres |
| ccp_backrest_last_info_backup_runtime_seconds | ClusterName,<br>backup_type,<br>job,<br>namespace,<br>pod,<br>server,<br>service,<br>stanza | sas-postgres |
| ccp_backrest_last_info_repo_backup_size_bytes | ClusterName,<br>backup_type,<br>job,<br>namespace,<br>pod,<br>server,<br>service,<br>stanza | sas-postgres |
| ccp_backrest_last_info_repo_total_size_bytes | ClusterName,<br>backup_type,<br>job,<br>namespace,<br>pod,<br>server,<br>service,<br>stanza | sas-postgres |
| ccp_connection_stats_active | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_connection_stats_idle | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_connection_stats_idle_in_txn | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_connection_stats_max_blocked_query_time | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_connection_stats_max_connections | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_connection_stats_max_idle_in_txn_time | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_connection_stats_max_query_time | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_connection_stats_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_data_checksum_failure_time_since_last_failure_seconds | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_data_checksum_failure_time_since_last_failure_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_database_size_bytes | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_is_in_recovery_status | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_locks_count | ClusterName,<br>dbname,<br>job,<br>mode,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_nodemx_cpu_limit | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_nodemx_cpu_request | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_nodemx_cpuacct_usage | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_nodemx_cpucfs_period_us | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_nodemx_cpucfs_quota_us | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_nodemx_cpustat_nr_periods | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_nodemx_cpustat_nr_throttled | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_nodemx_cpustat_throttled_time | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_nodemx_data_disk_available_bytes | ClusterName,<br>fs_type,<br>job,<br>mount_point,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_nodemx_data_disk_free_file_nodes | ClusterName,<br>fs_type,<br>job,<br>mount_point,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_nodemx_data_disk_total_bytes | ClusterName,<br>fs_type,<br>job,<br>mount_point,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_nodemx_data_disk_total_file_nodes | ClusterName,<br>fs_type,<br>job,<br>mount_point,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_nodemx_disk_activity_sectors_read | ClusterName,<br>job,<br>mount_point,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_nodemx_disk_activity_sectors_written | ClusterName,<br>job,<br>mount_point,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_nodemx_mem_active_anon | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_nodemx_mem_active_file | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_nodemx_mem_cache | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_nodemx_mem_inactive_anon | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_nodemx_mem_inactive_file | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_nodemx_mem_limit | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_nodemx_mem_mapped_file | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_nodemx_mem_request | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_nodemx_mem_rss | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_nodemx_network_rx_bytes | ClusterName,<br>interface,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_nodemx_network_rx_packets | ClusterName,<br>interface,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_nodemx_network_tx_bytes | ClusterName,<br>interface,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_nodemx_network_tx_packets | ClusterName,<br>interface,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_nodemx_process_count | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_pg_hba_checksum_status | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_pg_settings_checksum_status | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_postgresql_version_current | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_postmaster_runtime_start_time_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_postmaster_uptime_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_replication_lag_size_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>replica,<br>replica_port,<br>server,<br>service | sas-postgres |
| ccp_sequence_exhaustion_count | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_settings_gauge_checkpoint_completion_target | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_settings_gauge_checkpoint_timeout | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_settings_gauge_shared_buffers | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_settings_pending_restart_count | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_stat_bgwriter_buffers_alloc | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_stat_bgwriter_buffers_backend | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_stat_bgwriter_buffers_backend_fsync | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_stat_bgwriter_buffers_checkpoint | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_stat_bgwriter_buffers_clean | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_stat_bgwriter_checkpoint_sync_time | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_stat_bgwriter_checkpoint_write_time | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_stat_bgwriter_checkpoints_req | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_stat_bgwriter_checkpoints_timed | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_stat_bgwriter_maxwritten_clean | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_stat_bgwriter_stats_reset | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_stat_database_blks_hit | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_stat_database_blks_read | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_stat_database_conflicts | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_stat_database_deadlocks | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_stat_database_temp_bytes | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_stat_database_temp_files | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_stat_database_tup_deleted | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_stat_database_tup_fetched | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_stat_database_tup_inserted | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_stat_database_tup_returned | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_stat_database_tup_updated | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_stat_database_xact_commit | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_stat_database_xact_rollback | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_stat_user_tables_analyze_count | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>relname,<br>schemaname,<br>server,<br>service | sas-postgres |
| ccp_stat_user_tables_autoanalyze_count | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>relname,<br>schemaname,<br>server,<br>service | sas-postgres |
| ccp_stat_user_tables_autovacuum_count | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>relname,<br>schemaname,<br>server,<br>service | sas-postgres |
| ccp_stat_user_tables_idx_scan | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>relname,<br>schemaname,<br>server,<br>service | sas-postgres |
| ccp_stat_user_tables_idx_tup_fetch | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>relname,<br>schemaname,<br>server,<br>service | sas-postgres |
| ccp_stat_user_tables_n_dead_tup | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>relname,<br>schemaname,<br>server,<br>service | sas-postgres |
| ccp_stat_user_tables_n_live_tup | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>relname,<br>schemaname,<br>server,<br>service | sas-postgres |
| ccp_stat_user_tables_n_tup_del | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>relname,<br>schemaname,<br>server,<br>service | sas-postgres |
| ccp_stat_user_tables_n_tup_hot_upd | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>relname,<br>schemaname,<br>server,<br>service | sas-postgres |
| ccp_stat_user_tables_n_tup_ins | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>relname,<br>schemaname,<br>server,<br>service | sas-postgres |
| ccp_stat_user_tables_n_tup_upd | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>relname,<br>schemaname,<br>server,<br>service | sas-postgres |
| ccp_stat_user_tables_seq_scan | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>relname,<br>schemaname,<br>server,<br>service | sas-postgres |
| ccp_stat_user_tables_seq_tup_read | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>relname,<br>schemaname,<br>server,<br>service | sas-postgres |
| ccp_stat_user_tables_vacuum_count | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>relname,<br>schemaname,<br>server,<br>service | sas-postgres |
| ccp_table_size_size_bytes | ClusterName,<br>dbname,<br>job,<br>namespace,<br>pod,<br>relname,<br>schemaname,<br>server,<br>service | sas-postgres |
| ccp_transaction_wraparound_oldest_current_xid | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_transaction_wraparound_percent_towards_emergency_autovac | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_transaction_wraparound_percent_towards_wraparound | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_wal_activity_last_5_min_size_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| ccp_wal_activity_total_size_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| erlang_mnesia_committed_transactions | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| erlang_mnesia_failed_transactions | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| erlang_mnesia_held_locks | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| erlang_mnesia_lock_queue | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| erlang_mnesia_logged_transactions | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| erlang_mnesia_restarted_transactions | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| erlang_mnesia_transaction_coordinators | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| erlang_mnesia_transaction_participants | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_allocators | ClusterName,<br>alloc,<br>instance_no,<br>job,<br>kind,<br>namespace,<br>pod,<br>service,<br>usage | sas-rabbitmq |
| erlang_vm_atom_count | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_atom_limit | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_dirty_cpu_schedulers | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_dirty_cpu_schedulers_online | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_dirty_io_schedulers | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_dist_node_queue_size_bytes | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_dist_node_state | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_dist_port_input_bytes | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_dist_port_memory_bytes | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_dist_port_output_bytes | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_dist_port_queue_size_bytes | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_dist_proc_heap_size_words | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service,<br>type | sas-rabbitmq |
| erlang_vm_dist_proc_memory_bytes | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service,<br>type | sas-rabbitmq |
| erlang_vm_dist_proc_message_queue_len | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service,<br>type | sas-rabbitmq |
| erlang_vm_dist_proc_min_bin_vheap_size_words | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service,<br>type | sas-rabbitmq |
| erlang_vm_dist_proc_min_heap_size_words | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service,<br>type | sas-rabbitmq |
| erlang_vm_dist_proc_reductions | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service,<br>type | sas-rabbitmq |
| erlang_vm_dist_proc_stack_size_words | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service,<br>type | sas-rabbitmq |
| erlang_vm_dist_proc_status | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service,<br>type | sas-rabbitmq |
| erlang_vm_dist_proc_total_heap_size_words | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service,<br>type | sas-rabbitmq |
| erlang_vm_dist_recv_avg_bytes | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_dist_recv_bytes | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_dist_recv_cnt | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_dist_recv_dvi_bytes | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_dist_recv_max_bytes | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_dist_send_avg_bytes | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_dist_send_bytes | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_dist_send_cnt | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_dist_send_max_bytes | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_dist_send_pend_bytes | ClusterName,<br>job,<br>namespace,<br>peer,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_ets_limit | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_logical_processors | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_logical_processors_available | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_logical_processors_online | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_memory_atom_bytes_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service,<br>usage | sas-rabbitmq |
| erlang_vm_memory_bytes_total | ClusterName,<br>job,<br>kind,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_memory_dets_tables | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_memory_ets_tables | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_memory_processes_bytes_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service,<br>usage | sas-rabbitmq |
| erlang_vm_memory_system_bytes_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service,<br>usage | sas-rabbitmq |
| erlang_vm_msacc_alloc_seconds_total | ClusterName,<br>id,<br>job,<br>namespace,<br>pod,<br>service,<br>type | sas-rabbitmq |
| erlang_vm_msacc_aux_seconds_total | ClusterName,<br>id,<br>job,<br>namespace,<br>pod,<br>service,<br>type | sas-rabbitmq |
| erlang_vm_msacc_bif_seconds_total | ClusterName,<br>id,<br>job,<br>namespace,<br>pod,<br>service,<br>type | sas-rabbitmq |
| erlang_vm_msacc_busy_wait_seconds_total | ClusterName,<br>id,<br>job,<br>namespace,<br>pod,<br>service,<br>type | sas-rabbitmq |
| erlang_vm_msacc_check_io_seconds_total | ClusterName,<br>id,<br>job,<br>namespace,<br>pod,<br>service,<br>type | sas-rabbitmq |
| erlang_vm_msacc_emulator_seconds_total | ClusterName,<br>id,<br>job,<br>namespace,<br>pod,<br>service,<br>type | sas-rabbitmq |
| erlang_vm_msacc_ets_seconds_total | ClusterName,<br>id,<br>job,<br>namespace,<br>pod,<br>service,<br>type | sas-rabbitmq |
| erlang_vm_msacc_gc_full_seconds_total | ClusterName,<br>id,<br>job,<br>namespace,<br>pod,<br>service,<br>type | sas-rabbitmq |
| erlang_vm_msacc_gc_seconds_total | ClusterName,<br>id,<br>job,<br>namespace,<br>pod,<br>service,<br>type | sas-rabbitmq |
| erlang_vm_msacc_nif_seconds_total | ClusterName,<br>id,<br>job,<br>namespace,<br>pod,<br>service,<br>type | sas-rabbitmq |
| erlang_vm_msacc_other_seconds_total | ClusterName,<br>id,<br>job,<br>namespace,<br>pod,<br>service,<br>type | sas-rabbitmq |
| erlang_vm_msacc_port_seconds_total | ClusterName,<br>id,<br>job,<br>namespace,<br>pod,<br>service,<br>type | sas-rabbitmq |
| erlang_vm_msacc_send_seconds_total | ClusterName,<br>id,<br>job,<br>namespace,<br>pod,<br>service,<br>type | sas-rabbitmq |
| erlang_vm_msacc_sleep_seconds_total | ClusterName,<br>id,<br>job,<br>namespace,<br>pod,<br>service,<br>type | sas-rabbitmq |
| erlang_vm_msacc_timers_seconds_total | ClusterName,<br>id,<br>job,<br>namespace,<br>pod,<br>service,<br>type | sas-rabbitmq |
| erlang_vm_port_count | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_port_limit | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_process_count | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_process_limit | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_schedulers | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_schedulers_online | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_smp_support | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_statistics_bytes_output_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_statistics_bytes_received_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_statistics_context_switches | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_statistics_dirty_cpu_run_queue_length | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_statistics_dirty_io_run_queue_length | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_statistics_garbage_collection_bytes_reclaimed | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_statistics_garbage_collection_number_of_gcs | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_statistics_garbage_collection_words_reclaimed | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_statistics_reductions_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_statistics_run_queues_length_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_statistics_runtime_milliseconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_statistics_wallclock_time_milliseconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_thread_pool_size | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_threads | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_time_correction | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| erlang_vm_wordsize_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| go_gc_duration_seconds | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>quantile,<br>sas_service_base,<br>service | sas-go |
| go_gc_duration_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>quantile,<br>service | sas-postgres |
| go_gc_duration_seconds_count | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| go_gc_duration_seconds_count | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-postgres |
| go_gc_duration_seconds_sum | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| go_gc_duration_seconds_sum | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-postgres |
| go_goroutines | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| go_goroutines | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-postgres |
| go_memstats_alloc_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| go_memstats_alloc_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-postgres |
| go_memstats_alloc_bytes_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| go_memstats_alloc_bytes_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-postgres |
| go_memstats_buck_hash_sys_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| go_memstats_buck_hash_sys_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-postgres |
| go_memstats_frees_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| go_memstats_frees_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-postgres |
| go_memstats_gc_cpu_fraction | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| go_memstats_gc_cpu_fraction | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-postgres |
| go_memstats_gc_sys_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| go_memstats_gc_sys_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-postgres |
| go_memstats_heap_alloc_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| go_memstats_heap_alloc_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-postgres |
| go_memstats_heap_idle_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| go_memstats_heap_idle_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-postgres |
| go_memstats_heap_inuse_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| go_memstats_heap_inuse_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-postgres |
| go_memstats_heap_objects | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| go_memstats_heap_objects | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-postgres |
| go_memstats_heap_released_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| go_memstats_heap_released_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-postgres |
| go_memstats_heap_sys_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| go_memstats_heap_sys_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-postgres |
| go_memstats_last_gc_time_seconds | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| go_memstats_last_gc_time_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-postgres |
| go_memstats_lookups_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| go_memstats_lookups_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-postgres |
| go_memstats_mallocs_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| go_memstats_mallocs_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-postgres |
| go_memstats_mcache_inuse_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| go_memstats_mcache_inuse_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-postgres |
| go_memstats_mcache_sys_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| go_memstats_mcache_sys_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-postgres |
| go_memstats_mspan_inuse_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| go_memstats_mspan_inuse_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-postgres |
| go_memstats_mspan_sys_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| go_memstats_mspan_sys_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-postgres |
| go_memstats_next_gc_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| go_memstats_next_gc_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-postgres |
| go_memstats_other_sys_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| go_memstats_other_sys_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-postgres |
| go_memstats_stack_inuse_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| go_memstats_stack_inuse_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-postgres |
| go_memstats_stack_sys_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| go_memstats_stack_sys_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-postgres |
| go_memstats_sys_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| go_memstats_sys_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-postgres |
| go_threads | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| go_threads | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-postgres |
| http_client_requests_seconds_count | ClusterName,<br>job,<br>method,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>status,<br>uri | sas-java |
| http_client_requests_seconds_max | ClusterName,<br>job,<br>method,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>status,<br>uri | sas-java |
| http_client_requests_seconds_sum | ClusterName,<br>job,<br>method,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>status,<br>uri | sas-java |
| http_server_requests_seconds_count | ClusterName,<br>job,<br>method,<br>namespace,<br>node,<br>outcome,<br>pod,<br>sas_service_base,<br>status,<br>uri | sas-java |
| http_server_requests_seconds_max | ClusterName,<br>job,<br>method,<br>namespace,<br>node,<br>outcome,<br>pod,<br>sas_service_base,<br>status,<br>uri | sas-java |
| http_server_requests_seconds_sum | ClusterName,<br>job,<br>method,<br>namespace,<br>node,<br>outcome,<br>pod,<br>sas_service_base,<br>status,<br>uri | sas-java |
| jdbc_connections_active | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| jdbc_connections_idle | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| jdbc_connections_max | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| jdbc_connections_min | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| jvm_buffer_count_buffers | ClusterName,<br>id,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| jvm_buffer_memory_used_bytes | ClusterName,<br>id,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| jvm_buffer_total_capacity_bytes | ClusterName,<br>id,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| jvm_classes_loaded_classes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| jvm_classes_unloaded_classes_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| jvm_gc_live_data_size_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| jvm_gc_max_data_size_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| jvm_gc_memory_allocated_bytes_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| jvm_gc_memory_promoted_bytes_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| jvm_gc_pause_seconds_count | ClusterName,<br>action,<br>cause,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| jvm_gc_pause_seconds_max | ClusterName,<br>action,<br>cause,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| jvm_gc_pause_seconds_sum | ClusterName,<br>action,<br>cause,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| jvm_memory_committed_bytes | ClusterName,<br>area,<br>id,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| jvm_memory_max_bytes | ClusterName,<br>area,<br>id,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| jvm_memory_used_bytes | ClusterName,<br>area,<br>id,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| jvm_threads_daemon_threads | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| jvm_threads_live_threads | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| jvm_threads_peak_threads | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| jvm_threads_states_threads | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>state | sas-java |
| log_events_total | ClusterName,<br>job,<br>level,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| log_events_total | ClusterName,<br>job,<br>level,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| pg_exporter_last_scrape_duration_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-postgres |
| pg_exporter_last_scrape_error | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-postgres |
| pg_exporter_scrapes_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-postgres |
| pg_exporter_user_queries_load_error | ClusterName,<br>filename,<br>hashsum,<br>job,<br>namespace,<br>pod,<br>service | sas-postgres |
| pg_locks_count | ClusterName,<br>datname,<br>job,<br>mode,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_allow_system_table_mods | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_archive_timeout_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_array_nulls | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_authentication_timeout_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_autovacuum | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_autovacuum_analyze_scale_factor | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_autovacuum_analyze_threshold | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_autovacuum_freeze_max_age | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_autovacuum_max_workers | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_autovacuum_multixact_freeze_max_age | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_autovacuum_naptime_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_autovacuum_vacuum_cost_delay_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_autovacuum_vacuum_cost_limit | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_autovacuum_vacuum_scale_factor | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_autovacuum_vacuum_threshold | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_autovacuum_work_mem_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_backend_flush_after_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_bgwriter_delay_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_bgwriter_flush_after_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_bgwriter_lru_maxpages | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_bgwriter_lru_multiplier | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_block_size | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_bonjour | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_check_function_bodies | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_checkpoint_completion_target | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_checkpoint_flush_after_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_checkpoint_timeout_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_checkpoint_warning_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_commit_delay | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_commit_siblings | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_cpu_index_tuple_cost | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_cpu_operator_cost | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_cpu_tuple_cost | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_cursor_tuple_fraction | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_data_checksums | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_data_directory_mode | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_data_sync_retry | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_db_user_namespace | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_deadlock_timeout_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_debug_assertions | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_debug_pretty_print | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_debug_print_parse | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_debug_print_plan | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_debug_print_rewritten | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_default_statistics_target | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_default_transaction_deferrable | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_default_transaction_read_only | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_effective_cache_size_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_effective_io_concurrency | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_enable_bitmapscan | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_enable_gathermerge | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_enable_hashagg | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_enable_hashjoin | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_enable_indexonlyscan | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_enable_indexscan | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_enable_material | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_enable_mergejoin | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_enable_nestloop | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_enable_parallel_append | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_enable_parallel_hash | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_enable_partition_pruning | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_enable_partitionwise_aggregate | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_enable_partitionwise_join | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_enable_seqscan | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_enable_sort | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_enable_tidscan | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_escape_string_warning | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_exit_on_error | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_extra_float_digits | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_from_collapse_limit | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_fsync | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_full_page_writes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_geqo | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_geqo_effort | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_geqo_generations | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_geqo_pool_size | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_geqo_seed | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_geqo_selection_bias | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_geqo_threshold | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_gin_fuzzy_search_limit | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_gin_pending_list_limit_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_hot_standby | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_hot_standby_feedback | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_idle_in_transaction_session_timeout_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_ignore_checksum_failure | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_ignore_system_indexes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_integer_datetimes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_jit | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_jit_above_cost | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_jit_debugging_support | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_jit_dump_bitcode | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_jit_expressions | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_jit_inline_above_cost | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_jit_optimize_above_cost | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_jit_profiling_support | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_jit_tuple_deforming | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_join_collapse_limit | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_krb_caseins_users | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_lo_compat_privileges | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_lock_timeout_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_log_autovacuum_min_duration_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_log_checkpoints | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_log_connections | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_log_disconnections | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_log_duration | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_log_executor_stats | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_log_file_mode | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_log_hostname | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_log_lock_waits | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_log_min_duration_statement_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_log_parser_stats | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_log_planner_stats | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_log_replication_commands | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_log_rotation_age_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_log_rotation_size_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_log_statement_stats | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_log_temp_files_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_log_transaction_sample_rate | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_log_truncate_on_rotation | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_logging_collector | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_maintenance_work_mem_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_max_connections | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_max_files_per_process | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_max_function_args | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_max_identifier_length | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_max_index_keys | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_max_locks_per_transaction | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_max_logical_replication_workers | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_max_parallel_maintenance_workers | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_max_parallel_workers | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_max_parallel_workers_per_gather | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_max_pred_locks_per_page | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_max_pred_locks_per_relation | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_max_pred_locks_per_transaction | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_max_prepared_transactions | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_max_replication_slots | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_max_stack_depth_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_max_standby_archive_delay_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_max_standby_streaming_delay_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_max_sync_workers_per_subscription | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_max_wal_senders | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_max_wal_size_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_max_worker_processes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_min_parallel_index_scan_size_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_min_parallel_table_scan_size_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_min_wal_size_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_old_snapshot_threshold_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_operator_precedence_warning | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_parallel_leader_participation | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_parallel_setup_cost | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_parallel_tuple_cost | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_pg_stat_statements_max | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_pg_stat_statements_save | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_pg_stat_statements_track_utility | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_pgaudit_log_catalog | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_pgaudit_log_client | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_pgaudit_log_parameter | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_pgaudit_log_relation | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_pgaudit_log_statement_once | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_pgnodemx_cgroup_enabled | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_pgnodemx_containerized | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_pgnodemx_kdapi_enabled | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_plpgsql_check_asserts | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_plpgsql_print_strict_params | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_port | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_post_auth_delay_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_pre_auth_delay_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_quote_all_identifiers | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_random_page_cost | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_recovery_min_apply_delay_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_recovery_target_inclusive | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_restart_after_crash | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_row_security | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_segment_size_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_seq_page_cost | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_server_version_num | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_shared_buffers_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_ssl | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_ssl_passphrase_command_supports_reload | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_ssl_prefer_server_ciphers | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_standard_conforming_strings | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_statement_timeout_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_superuser_reserved_connections | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_synchronize_seqscans | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_syslog_sequence_numbers | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_syslog_split_messages | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_tcp_keepalives_count | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_tcp_keepalives_idle_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_tcp_keepalives_interval_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_tcp_user_timeout_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_temp_buffers_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_temp_file_limit_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_trace_notify | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_trace_sort | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_track_activities | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_track_activity_query_size_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_track_commit_timestamp | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_track_counts | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_track_io_timing | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_transaction_deferrable | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_transaction_read_only | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_transform_null_equals | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_unix_socket_permissions | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_update_process_title | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_vacuum_cleanup_index_scale_factor | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_vacuum_cost_delay_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_vacuum_cost_limit | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_vacuum_cost_page_dirty | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_vacuum_cost_page_hit | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_vacuum_cost_page_miss | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_vacuum_defer_cleanup_age | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_vacuum_freeze_min_age | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_vacuum_freeze_table_age | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_vacuum_multixact_freeze_min_age | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_vacuum_multixact_freeze_table_age | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_wal_block_size | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_wal_buffers_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_wal_compression | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_wal_init_zero | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_wal_keep_segments | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_wal_log_hints | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_wal_receiver_status_interval_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_wal_receiver_timeout_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_wal_recycle | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_wal_retrieve_retry_interval_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_wal_segment_size_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_wal_sender_timeout_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_wal_writer_delay_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_wal_writer_flush_after_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_work_mem_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_settings_zero_damaged_pages | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_activity_count | ClusterName,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service,<br>state | sas-postgres |
| pg_stat_activity_max_tx_duration | ClusterName,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service,<br>state | sas-postgres |
| pg_stat_archiver_archived_count | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_archiver_failed_count | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_archiver_last_archive_age | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_bgwriter_buffers_alloc | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_bgwriter_buffers_backend | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_bgwriter_buffers_backend_fsync | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_bgwriter_buffers_checkpoint | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_bgwriter_buffers_clean | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_bgwriter_checkpoint_sync_time | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_bgwriter_checkpoint_write_time | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_bgwriter_checkpoints_req | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_bgwriter_checkpoints_timed | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_bgwriter_maxwritten_clean | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_bgwriter_stats_reset | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_database_blk_read_time | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_database_blk_read_time | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_database_blk_write_time | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_database_blk_write_time | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_database_blks_hit | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_database_blks_hit | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_database_blks_read | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_database_blks_read | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_database_conflicts | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_database_conflicts | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_database_conflicts_confl_bufferpin | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_database_conflicts_confl_deadlock | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_database_conflicts_confl_lock | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_database_conflicts_confl_snapshot | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_database_conflicts_confl_tablespace | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_database_deadlocks | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_database_deadlocks | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_database_numbackends | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_database_numbackends | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_database_stats_reset | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_database_stats_reset | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_database_temp_bytes | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_database_temp_bytes | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_database_temp_files | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_database_temp_files | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_database_tup_deleted | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_database_tup_deleted | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_database_tup_fetched | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_database_tup_fetched | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_database_tup_inserted | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_database_tup_inserted | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_database_tup_returned | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_database_tup_returned | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_database_tup_updated | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_database_tup_updated | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_database_xact_commit | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_database_xact_commit | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_database_xact_rollback | ClusterName,<br>datid,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_stat_database_xact_rollback | ClusterName,<br>datid,<br>datname,<br>job,<br>namespace,<br>pod,<br>server,<br>service | sas-postgres |
| pg_static | ClusterName,<br>job,<br>namespace,<br>pod,<br>server,<br>service,<br>short_version,<br>version | sas-postgres |
| pg_up | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-postgres |
| process_cpu_seconds_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| process_cpu_seconds_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-postgres |
| process_cpu_usage | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| process_files_max_files | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| process_files_open_files | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| process_max_fds | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| process_max_fds | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-postgres |
| process_open_fds | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| process_open_fds | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-postgres |
| process_resident_memory_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| process_resident_memory_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-postgres |
| process_start_time_seconds | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| process_start_time_seconds | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| process_start_time_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-postgres |
| process_uptime_seconds | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| process_virtual_memory_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| process_virtual_memory_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-postgres |
| process_virtual_memory_max_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| process_virtual_memory_max_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-postgres |
| rabbitmq_acknowledged_published_total | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| rabbitmq_acknowledged_total | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| rabbitmq_auth_attempts_failed_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>protocol,<br>service | sas-rabbitmq |
| rabbitmq_auth_attempts_succeeded_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>protocol,<br>service | sas-rabbitmq |
| rabbitmq_auth_attempts_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>protocol,<br>service | sas-rabbitmq |
| rabbitmq_channel_acks_uncommitted | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_channel_consumers | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_channel_get_ack_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_channel_get_empty_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_channel_get_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_channel_messages_acked_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_channel_messages_confirmed_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_channel_messages_delivered_ack_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_channel_messages_delivered_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_channel_messages_published_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_channel_messages_redelivered_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_channel_messages_unacked | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_channel_messages_uncommitted | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_channel_messages_unconfirmed | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_channel_messages_unroutable_dropped_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_channel_messages_unroutable_returned_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_channel_prefetch | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_channel_process_reductions_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_channels | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| rabbitmq_channels | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_channels_closed_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_channels_opened_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_connection_channels | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_connection_incoming_bytes_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_connection_incoming_packets_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_connection_outgoing_bytes_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_connection_outgoing_packets_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_connection_pending_packets | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_connection_process_reductions_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_connections | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| rabbitmq_connections | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_connections_closed_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_connections_opened_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_consumed_total | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| rabbitmq_consumer_prefetch | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_consumers | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_disk_space_available_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_disk_space_available_limit_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_erlang_gc_reclaimed_bytes_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_erlang_gc_runs_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_erlang_net_ticktime_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_erlang_processes_limit | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_erlang_processes_used | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_erlang_scheduler_context_switches_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_erlang_scheduler_run_queue | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_erlang_uptime_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_failed_to_publish_total | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| rabbitmq_io_open_attempt_ops_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_io_open_attempt_time_seconds_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_io_read_bytes_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_io_read_ops_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_io_read_time_seconds_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_io_reopen_ops_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_io_seek_ops_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_io_seek_time_seconds_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_io_sync_ops_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_io_sync_time_seconds_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_io_write_bytes_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_io_write_ops_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_io_write_time_seconds_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_msg_store_read_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_msg_store_write_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_not_acknowledged_published_total | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| rabbitmq_process_max_fds | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_process_max_tcp_sockets | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_process_open_fds | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_process_open_tcp_sockets | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_process_resident_memory_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_published_total | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| rabbitmq_queue_consumer_utilisation | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_queue_consumers | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_queue_disk_reads_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_queue_disk_writes_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_queue_index_journal_write_ops_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_queue_index_read_ops_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_queue_index_write_ops_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_queue_messages | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_queue_messages_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_queue_messages_paged_out | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_queue_messages_paged_out_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_queue_messages_persistent | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_queue_messages_published_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_queue_messages_ram | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_queue_messages_ram_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_queue_messages_ready | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_queue_messages_ready_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_queue_messages_ready_ram | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_queue_messages_unacked | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_queue_messages_unacked_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_queue_messages_unacked_ram | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_queue_process_memory_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_queue_process_reductions_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_queues | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_queues_created_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_queues_declared_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_queues_deleted_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_raft_entry_commit_latency_seconds | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_raft_log_commit_index | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_raft_log_last_applied_index | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_raft_log_last_written_index | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_raft_log_snapshot_index | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_raft_term_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_rejected_total | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| rabbitmq_resident_memory_limit_bytes | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_schema_db_disk_tx_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_schema_db_ram_tx_total | ClusterName,<br>job,<br>namespace,<br>pod,<br>service | sas-rabbitmq |
| rabbitmq_unrouted_published_total | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| runtime_alloc_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| runtime_free_count | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| runtime_heap_objects | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| runtime_malloc_count | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| runtime_num_goroutines | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| runtime_sys_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| runtime_total_gc_pause_ns | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| runtime_total_gc_runs | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| sas_db_closed_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>reason,<br>sas_service_base,<br>schema,<br>service | sas-go |
| sas_db_closed_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>reason,<br>sas_service_base,<br>service | sas-go |
| sas_db_connections_max | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service,<br>state | sas-go |
| sas_db_connections_max | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>schema,<br>service,<br>state | sas-go |
| sas_db_pool_connections | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service,<br>state | sas-go |
| sas_db_pool_connections | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>schema,<br>service,<br>state | sas-go |
| sas_db_wait_seconds | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| sas_db_wait_seconds | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>schema,<br>service | sas-go |
| sas_db_wait_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| sas_db_wait_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>schema,<br>service | sas-go |
| sas_maps_esri_query_duration_seconds_count | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| sas_maps_esri_query_duration_seconds_sum | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| sas_maps_report_polling_attempts_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| sas_maps_report_query_duration_seconds_count | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| sas_maps_report_query_duration_seconds_sum | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base,<br>service | sas-go |
| spring_integration_channels | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| spring_integration_handlers | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| spring_integration_sources | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| spring_rabbitmq_listener_seconds_count | ClusterName,<br>job,<br>listener_id,<br>namespace,<br>node,<br>pod,<br>queue,<br>result,<br>sas_service_base | sas-java |
| spring_rabbitmq_listener_seconds_max | ClusterName,<br>job,<br>listener_id,<br>namespace,<br>node,<br>pod,<br>queue,<br>result,<br>sas_service_base | sas-java |
| spring_rabbitmq_listener_seconds_sum | ClusterName,<br>job,<br>listener_id,<br>namespace,<br>node,<br>pod,<br>queue,<br>result,<br>sas_service_base | sas-java |
| system_cpu_count | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| system_cpu_usage | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| system_load_average_1m | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| telemetry_scrape_duration_seconds_count | ClusterName,<br>content_type,<br>job,<br>namespace,<br>pod,<br>registry,<br>service | sas-rabbitmq |
| telemetry_scrape_duration_seconds_sum | ClusterName,<br>content_type,<br>job,<br>namespace,<br>pod,<br>registry,<br>service | sas-rabbitmq |
| telemetry_scrape_encoded_size_bytes_count | ClusterName,<br>content_type,<br>encoding,<br>job,<br>namespace,<br>pod,<br>registry,<br>service | sas-rabbitmq |
| telemetry_scrape_encoded_size_bytes_sum | ClusterName,<br>content_type,<br>encoding,<br>job,<br>namespace,<br>pod,<br>registry,<br>service | sas-rabbitmq |
| telemetry_scrape_size_bytes_count | ClusterName,<br>content_type,<br>job,<br>namespace,<br>pod,<br>registry,<br>service | sas-rabbitmq |
| telemetry_scrape_size_bytes_sum | ClusterName,<br>content_type,<br>job,<br>namespace,<br>pod,<br>registry,<br>service | sas-rabbitmq |
| tomcat_cache_access_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| tomcat_cache_hit_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| tomcat_global_error_total | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| tomcat_global_received_bytes_total | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| tomcat_global_request_max_seconds | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| tomcat_global_request_seconds_count | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| tomcat_global_request_seconds_sum | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| tomcat_global_sent_bytes_total | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| tomcat_servlet_error_total | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| tomcat_servlet_request_max_seconds | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| tomcat_servlet_request_seconds_count | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| tomcat_servlet_request_seconds_sum | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| tomcat_sessions_active_current_sessions | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| tomcat_sessions_active_max_sessions | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| tomcat_sessions_alive_max_seconds | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| tomcat_sessions_created_sessions_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| tomcat_sessions_expired_sessions_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| tomcat_sessions_rejected_sessions_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| tomcat_threads_busy_threads | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| tomcat_threads_config_max_threads | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| tomcat_threads_current_threads | ClusterName,<br>job,<br>name,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| zipkin_reporter_messages_bytes_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| zipkin_reporter_messages_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| zipkin_reporter_queue_bytes | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| zipkin_reporter_queue_spans | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| zipkin_reporter_spans_bytes_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| zipkin_reporter_spans_dropped_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |
| zipkin_reporter_spans_total | ClusterName,<br>job,<br>namespace,<br>node,<br>pod,<br>sas_service_base | sas-java |

</details>
