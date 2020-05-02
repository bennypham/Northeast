-------------
--FUNCTIONS--
-------------
CREATE OR REPLACE FUNCTION PopulatePlaneID() RETURNS TRIGGER AS $$
   BEGIN
      NEW.id := nextval('plane_id');
      RETURN NEW;
   END;
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION PopulateFlightInfoID() RETURNS TRIGGER AS $$
   BEGIN
      NEW.fiid := nextval('fiid');
      RETURN NEW;
   END;
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION PopulateReservation() RETURNS TRIGGER AS $$
   DECLARE
    seat_available text;
   BEGIN
      SELECT *
      INTO seat_available
      FROM FlightInfo, Plane, Flight
      WHERE 
        FlightInfo.flight_id = NEW.fid AND
        FlightInfo.plane_id = Plane.id AND
        FlightInfo.flight_id = Flight.fnum AND
        Flight.num_sold < Plane.seats;
      
      IF FOUND THEN
        NEW.status := 'C';
      ELSE
        NEW.status := 'W';
      END IF;

      NEW.rnum := nextval('rnum');

      RETURN NEW;
   END;
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION PopulatePilotID() RETURNS TRIGGER AS $$
   BEGIN
      NEW.id := nextval('pilot_id');
      RETURN NEW;
   END;
$$ LANGUAGE 'plpgsql';

CREATE OR REPLACE FUNCTION PopulateTechnicianID() RETURNS TRIGGER AS $$
   BEGIN
      NEW.id := nextval('technician_id');
      RETURN NEW;
   END;
$$ LANGUAGE 'plpgsql';

-------------
--TRIGGERS---
-------------
CREATE TRIGGER populate_plane_id
BEFORE INSERT ON Plane
FOR EACH ROW
EXECUTE PROCEDURE PopulatePlaneID();

CREATE TRIGGER populate_fiid
BEFORE INSERT ON FlightInfo
FOR EACH ROW
EXECUTE PROCEDURE PopulateFlightInfoID();

CREATE TRIGGER populate_reservation
BEFORE INSERT ON Reservation
FOR EACH ROW
EXECUTE PROCEDURE PopulateReservation();

CREATE TRIGGER populate_pilot_id
BEFORE INSERT ON Pilot
FOR EACH ROW
EXECUTE PROCEDURE PopulatePilotID();

CREATE TRIGGER populate_technician_id
BEFORE INSERT ON Technician
FOR EACH ROW
EXECUTE PROCEDURE PopulateTechnicianID();
