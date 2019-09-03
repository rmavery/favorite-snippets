

CREATE ROLE [update_ad_tables] AUTHORIZATION [dbo]


-- One way is to use a 'schema'.  Scripts are not currently configured to be in a schema, so you would 
-- have to modify it all.   
CREATE schema ad authorization dbo 
GRANT SELECT, INSERT, UPDATE, DELETE, ALTER  ON SCHEMA::ad to [update_ad_tables]


--select * from ad_users 
--select * from ad_members 
--select * from ad_groups 
--select * from ad_objects 
--select * from ad_computers 
-- If objects are in the dbo schema, you can grant access to EACH OBJECT individually 

GRANT SELECT, INSERT, UPDATE, DELETE, ALTER ON [dbo].[_ad_groups] TO [update_ad_tables]
GRANT SELECT, INSERT, UPDATE, DELETE, ALTER ON [dbo].[ad_users] TO [update_ad_tables]
GRANT SELECT, INSERT, UPDATE, DELETE, ALTER ON [dbo].[ad_members] TO [update_ad_tables]
GRANT SELECT, INSERT, UPDATE, DELETE, ALTER ON [dbo].[_ad_users] TO [update_ad_tables]
GRANT SELECT, INSERT, UPDATE, DELETE, ALTER ON [dbo].[_ad_group_members] TO [update_ad_tables]
GRANT SELECT, INSERT, UPDATE, DELETE, ALTER ON [dbo].[_ad_user_memberOf] TO [update_ad_tables]
GRANT SELECT, INSERT, UPDATE, DELETE, ALTER ON [dbo].[ad_groups] TO [update_ad_tables]
GRANT SELECT, INSERT, UPDATE, DELETE, ALTER ON [dbo].[_ad_group_memberOf] TO [update_ad_tables]
GRANT SELECT, INSERT, UPDATE, DELETE, ALTER ON [dbo].[ad_objects] TO [update_ad_tables]
GRANT SELECT, INSERT, UPDATE, DELETE, ALTER ON [dbo].[_ad_objects] TO [update_ad_tables]
GRANT SELECT, INSERT, UPDATE, DELETE, ALTER ON [dbo].[_ad_computer_memberOf] TO [update_ad_tables]
GRANT SELECT, INSERT, UPDATE, DELETE, ALTER ON [dbo].[ad_computer_spns] TO [update_ad_tables]
GRANT SELECT, INSERT, UPDATE, DELETE, ALTER ON [dbo].[_ad_computer_spns] TO [update_ad_tables]
GRANT SELECT, INSERT, UPDATE, DELETE, ALTER ON [dbo].[ad_computers] TO [update_ad_tables]
GRANT SELECT, INSERT, UPDATE, DELETE, ALTER ON [dbo].[_ad_computers] TO [update_ad_tables]
GRANT SELECT ON [dbo].[vw_ad_managers] TO [update_ad_tables] 
GRANT EXECUTE ON [dbo].[ad_insert_update_ad_computers] TO [update_ad_tables]
GRANT EXECUTE ON [dbo].[ad_insert_update_ad_users] TO [update_ad_tables]
GRANT EXECUTE ON [dbo].[ad_insert_update_ad_objects] TO [update_ad_tables]
GRANT EXECUTE ON [dbo].[ad_insert_update_ad_groups] TO [update_ad_tables]

