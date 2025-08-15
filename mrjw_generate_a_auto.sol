pragma solidity ^0.8.0;

pragma abicoder v2;

contract MrJWGenerateAAuto {
    // Event emitted when a new pipeline is created
    event NewPipeline(address indexed owner, uint256 pipelineId);

    // Event emitted when a pipeline is updated
    event UpdatePipeline(uint256 pipelineId, string status);

    // Event emitted when a pipeline is deleted
    event DeletePipeline(uint256 pipelineId);

    // Mapping of pipeline IDs to their respective pipeline data
    mapping (uint256 => Pipeline) public pipelines;

    // Counter for pipeline IDs
    uint256 public pipelineIdCounter;

    // Struct to represent a pipeline
    struct Pipeline {
        address owner;
        string name;
        string description;
        string status; // "pending", "in_progress", "completed"
        uint256 createdAt;
        uint256 updatedAt;
    }

    // Function to create a new pipeline
    function createPipeline(string memory _name, string memory _description) public {
        Pipeline memory pipeline = Pipeline(
            msg.sender,
            _name,
            _description,
            "pending",
            block.timestamp,
            block.timestamp
        );
        pipelineIdCounter++;
        pipelines[pipelineIdCounter] = pipeline;
        emit NewPipeline(msg.sender, pipelineIdCounter);
    }

    // Function to update a pipeline
    function updatePipeline(uint256 _pipelineId, string memory _status) public {
        Pipeline storage pipeline = pipelines[_pipelineId];
        require(pipeline.owner == msg.sender, "Only the pipeline owner can update it");
        pipeline.status = _status;
        pipeline.updatedAt = block.timestamp;
        emit UpdatePipeline(_pipelineId, _status);
    }

    // Function to delete a pipeline
    function deletePipeline(uint256 _pipelineId) public {
        Pipeline storage pipeline = pipelines[_pipelineId];
        require(pipeline.owner == msg.sender, "Only the pipeline owner can delete it");
        delete pipelines[_pipelineId];
        emit DeletePipeline(_pipelineId);
    }

    // Function to get a pipeline by ID
    function getPipeline(uint256 _pipelineId) public view returns (Pipeline memory) {
        return pipelines[_pipelineId];
    }

    // Function to get all pipelines owned by a user
    function getPipelinesByOwner(address _owner) public view returns (Pipeline[] memory) {
        Pipeline[] memory userPipelines = new Pipeline[](pipelineIdCounter);
        uint256 counter = 0;
        for (uint256 i = 1; i <= pipelineIdCounter; i++) {
            if (pipelines[i].owner == _owner) {
                userPipelines[counter] = pipelines[i];
                counter++;
            }
        }
        return userPipelines;
    }
}