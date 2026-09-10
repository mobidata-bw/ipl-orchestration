<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor version="1.0.0"
                       xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.0.0/StyledLayerDescriptor.xsd"
                       xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc"
                       xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

  <NamedLayer>
    <Name>mdbw_park-api_sites_occupancy</Name>
    <UserStyle>
      <Title>MobiData BW® - Parkbau und -streifen (nach Belegung)</Title>
      <FeatureTypeStyle>
        <Rule>
          <Title>Geschlossen</Title>
          <ogc:Filter>
            <ogc:PropertyIsEqualTo>
              <ogc:PropertyName>realtime_opening_status</ogc:PropertyName>
              <ogc:Literal>CLOSED</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <PointSymbolizer>
            <Graphic>
              <Mark>
                <WellKnownName>circle</WellKnownName>
                <Fill>
                  <CssParameter name="fill">#ed0000</CssParameter> 
                </Fill>
                <Stroke/>
              </Mark>
              <Size>10</Size>
            </Graphic>
          </PointSymbolizer>
        </Rule>
        <Rule>        
          <Title>Keine Echtzeitinformationen</Title>         
          <ogc:Filter>            
            <ogc:PropertyIsNull>
              <ogc:PropertyName>realtime_free_capacity</ogc:PropertyName>
            </ogc:PropertyIsNull>         
          </ogc:Filter>
          <PointSymbolizer>
            <Graphic>
              <Mark>
                <WellKnownName>circle</WellKnownName>
                <Fill>
                  <CssParameter name="fill">#615fdf</CssParameter>
                </Fill>
                <Stroke/>
              </Mark>
              <Size>10</Size>
            </Graphic>
          </PointSymbolizer>
        </Rule>
        <Rule>        
          <Title>Veraltete Echtzeitinformationen</Title>         
          <ogc:Filter>
            <ogc:PropertyIsEqualTo>
              <ogc:PropertyName>realtime_data_outdated</ogc:PropertyName>
              <ogc:Literal>true</ogc:Literal>
            </ogc:PropertyIsEqualTo>
          </ogc:Filter>
          <PointSymbolizer>
            <Graphic>
              <Mark>
                <WellKnownName>circle</WellKnownName>
                <Fill>
                  <CssParameter name="fill">#cacaca</CssParameter>
                </Fill>
                <Stroke/>
              </Mark>
              <Size>10</Size>
            </Graphic>
          </PointSymbolizer>
        </Rule>
        <Rule>
          <Title>Parkplätze verfügbar</Title>
          <ogc:Filter>
            <ogc:And>
              <ogc:PropertyIsGreaterThanOrEqualTo>
                <ogc:Div>
                  <ogc:Mul>
                    <ogc:PropertyName>realtime_free_capacity</ogc:PropertyName>
                    <ogc:Literal>1</ogc:Literal>
                  </ogc:Mul>
                  <ogc:Function name="if_then_else">
                    <ogc:Function name="isNull">
                      <ogc:PropertyName>realtime_capacity</ogc:PropertyName>
                    </ogc:Function>
                    <ogc:PropertyName>capacity</ogc:PropertyName>
                    <ogc:PropertyName>realtime_capacity</ogc:PropertyName>
                  </ogc:Function>
                </ogc:Div>
                <ogc:Literal>0.2</ogc:Literal>
              </ogc:PropertyIsGreaterThanOrEqualTo>
              <ogc:PropertyIsNotEqualTo>
                <ogc:PropertyName>realtime_opening_status</ogc:PropertyName>
                <ogc:Literal>CLOSED</ogc:Literal>
              </ogc:PropertyIsNotEqualTo>
              <ogc:PropertyIsNotEqualTo>
                <ogc:PropertyName>realtime_data_outdated</ogc:PropertyName>
                <ogc:Literal>true</ogc:Literal>
              </ogc:PropertyIsNotEqualTo>
            </ogc:And>
          </ogc:Filter>
          <PointSymbolizer>
            <Graphic>
              <Mark>
                <WellKnownName>circle</WellKnownName>
                <Fill>
                  <CssParameter name="fill">#059b02</CssParameter>
                </Fill>
                <Stroke/>
              </Mark>
              <Size>10</Size>
            </Graphic>
          </PointSymbolizer>
        </Rule>
        <Rule>
          <Title>Wenige Parkplätze verfügbar</Title>
          <ogc:Filter>
            <ogc:And>
              <ogc:PropertyIsBetween>
                <ogc:Div>
                  <ogc:Mul>
                    <ogc:PropertyName>realtime_free_capacity</ogc:PropertyName>
                    <ogc:Literal>1</ogc:Literal>
                  </ogc:Mul>
                  <ogc:Function name="if_then_else">
                    <ogc:Function name="isNull">
                      <ogc:PropertyName>realtime_capacity</ogc:PropertyName>
                    </ogc:Function>
                    <ogc:PropertyName>capacity</ogc:PropertyName>
                    <ogc:PropertyName>realtime_capacity</ogc:PropertyName>
                  </ogc:Function>
                </ogc:Div>
                <ogc:LowerBoundary>
                  <ogc:Literal>0.02</ogc:Literal>
                </ogc:LowerBoundary>
                <ogc:UpperBoundary>
                  <ogc:Literal>0.2</ogc:Literal>
                </ogc:UpperBoundary>        
              </ogc:PropertyIsBetween>
              <ogc:PropertyIsNotEqualTo>
                <ogc:PropertyName>realtime_opening_status</ogc:PropertyName>
                <ogc:Literal>CLOSED</ogc:Literal>
              </ogc:PropertyIsNotEqualTo>
              <ogc:PropertyIsNotEqualTo>
                <ogc:PropertyName>realtime_data_outdated</ogc:PropertyName>
                <ogc:Literal>true</ogc:Literal>
              </ogc:PropertyIsNotEqualTo>
            </ogc:And>
          </ogc:Filter>
          <PointSymbolizer>
            <Graphic>
              <Mark>
                <WellKnownName>circle</WellKnownName>
                <Fill>
                  <CssParameter name="fill">#dfab27</CssParameter>
                </Fill>
                <Stroke/>
              </Mark>
              <Size>10</Size>
            </Graphic>
          </PointSymbolizer>
        </Rule>
        <Rule>
          <Title>Keine oder sehr wenige Parkplätze verfügbar</Title>
          <ogc:Filter>
            <ogc:And>
              <ogc:PropertyIsGreaterThanOrEqualTo>
                <ogc:PropertyName>realtime_free_capacity</ogc:PropertyName>
                <ogc:Literal>0</ogc:Literal>
              </ogc:PropertyIsGreaterThanOrEqualTo>
              <ogc:PropertyIsLessThanOrEqualTo>
                <ogc:Div>
                  <ogc:Mul>
                    <ogc:PropertyName>realtime_free_capacity</ogc:PropertyName>
                    <ogc:Literal>1</ogc:Literal>
                  </ogc:Mul>
                  <ogc:Function name="if_then_else">
                    <ogc:Function name="isNull">
                      <ogc:PropertyName>realtime_capacity</ogc:PropertyName>
                    </ogc:Function>
                    <ogc:PropertyName>capacity</ogc:PropertyName>
                    <ogc:PropertyName>realtime_capacity</ogc:PropertyName>
                  </ogc:Function>
                </ogc:Div>
                <ogc:Literal>0.02</ogc:Literal>
              </ogc:PropertyIsLessThanOrEqualTo>
              <ogc:PropertyIsNotEqualTo>
                <ogc:PropertyName>realtime_opening_status</ogc:PropertyName>
                <ogc:Literal>CLOSED</ogc:Literal>
              </ogc:PropertyIsNotEqualTo>
              <ogc:PropertyIsNotEqualTo>
                <ogc:PropertyName>realtime_data_outdated</ogc:PropertyName>
                <ogc:Literal>true</ogc:Literal>
              </ogc:PropertyIsNotEqualTo>
            </ogc:And>
          </ogc:Filter>
          <PointSymbolizer>
            <Graphic>
              <Mark>
                <WellKnownName>circle</WellKnownName>
                <Fill>
                  <CssParameter name="fill">#ed0000</CssParameter>
                </Fill>
                <Stroke/>
              </Mark>
              <Size>10</Size>
            </Graphic>
          </PointSymbolizer>
        </Rule>
      </FeatureTypeStyle>
    </UserStyle>
  </NamedLayer>
</StyledLayerDescriptor>