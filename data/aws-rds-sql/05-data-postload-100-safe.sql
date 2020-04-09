ALTER TABLE pathwaysdos.services ENABLE TRIGGER beforerowinsertservices;

--
-- Name: services fk_8a44833f10ee4cee; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--
-- Commented out for slim 100 safe services as some have parent's that aren't being included
-- ALTER TABLE ONLY pathwaysdos.services
--     ADD CONSTRAINT fk_8a44833f10ee4cee FOREIGN KEY (parentid) REFERENCES pathwaysdos.services(id);

--
-- Name: services fk_8a44833f6b848fb5; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--
-- Commented out for slim 100 safe services as some have subregion's that aren't being included
-- ALTER TABLE ONLY pathwaysdos.services
--     ADD CONSTRAINT fk_8a44833f6b848fb5 FOREIGN KEY (subregionid) REFERENCES pathwaysdos.services(id);

--
-- Name: servicecapacities fk_fbf2e96844c57db; Type: FK CONSTRAINT; Schema: pathwaysdos; Owner: release_manager
--

ALTER TABLE ONLY pathwaysdos.servicecapacities
    ADD CONSTRAINT fk_fbf2e96844c57db FOREIGN KEY (capacitystatusid) REFERENCES pathwaysdos.capacitystatuses(capacitystatusid) ON DELETE CASCADE;
